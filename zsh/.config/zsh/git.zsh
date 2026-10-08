# ------------------------------
# Git Worktrees
# ------------------------------

# Add a worktree as a sibling directory with branch name suffix
# Creates the branch if it doesn't exist
# Usage: gwa <branch-name>
# Example: gwa feature-x  ->  ../repo-feature-x
gwa() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwa <branch-name>"
    return 1
  fi

  local branch="$1"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local repo_name=$(basename "$repo_root")
  local parent_dir=$(dirname "$repo_root")
  local worktree_path="$parent_dir/$repo_name-$branch"

  # Check if branch exists locally or remotely
  if git show-ref --verify --quiet "refs/heads/$branch" || \
     git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git worktree add "$worktree_path" "$branch"
  else
    git worktree add -b "$branch" "$worktree_path"
  fi
}

# Add a worktree and start a tmux session in it
# Usage: gwat <branch-name>
# Example: gwat feature-x  ->  creates ../repo-feature-x and opens tmux session
gwat() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwat <branch-name>"
    return 1
  fi

  local branch="$1"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local repo_name=$(basename "$repo_root")
  local parent_dir=$(dirname "$repo_root")
  local worktree_path="$parent_dir/$repo_name-$branch"

  gwa "$branch" || return 1

  if [[ -n "$TMUX" ]]; then
    # Already in tmux: create detached session and switch to it
    tmux new-session -d -s "$branch" -c "$worktree_path"
    tmux switch-client -t "$branch"
  else
    # Not in tmux: create and attach normally
    tmux new-session -s "$branch" -c "$worktree_path"
  fi
}

# Remove a worktree by branch name
# Usage: gwr <branch-name>
# Example: gwr feature-x  ->  removes ../repo-feature-x
gwr() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwr <branch-name>"
    return 1
  fi

  local branch="$1"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local repo_name=$(basename "$repo_root")
  local parent_dir=$(dirname "$repo_root")
  local worktree_path="$parent_dir/$repo_name-$branch"

  git worktree remove "$worktree_path"
}

# ------------------------------
# Branch Cleanup
# ------------------------------

# Delete local branches that are merged into HEAD, or whose GitHub PR was
# merged (e.g. squash merged)
# Skips protected branches, the current branch, branches checked out in other
# worktrees, and branches with commits not yet on their upstream or merged PR
# Usage: gclean
gclean() {
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Error: Not in a git repository"; return 1; }

  local use_gh=0
  (( $+commands[gh] )) && gh repo view --json name >/dev/null 2>&1 </dev/null && use_gh=1

  local branch upstream worktree tip prs pr pr_number pr_oid
  git for-each-ref --format='%(refname:short)|%(upstream)|%(worktreepath)' refs/heads |
  while IFS='|' read -r branch upstream worktree; do
    [[ "$branch" == (main|master|dev) || -n "$worktree" ]] && continue

    if git merge-base --is-ancestor "$branch" HEAD; then
      if [[ -n "$upstream" ]] && git show-ref --verify --quiet "$upstream" && \
         ! git merge-base --is-ancestor "$branch" "$upstream"; then
        echo "Skipping $branch (not merged to ${upstream#refs/remotes/})"
        continue
      fi

      git branch -d "$branch"
    elif (( use_gh )); then
      # Only delete if the local tip is contained in a merged PR's head, so
      # commits made after the merge are never lost
      tip=$(git rev-parse "$branch")
      prs=$(gh pr list --state merged --head "$branch" --limit 10 \
        --json number,headRefOid --jq '.[] | "\(.number) \(.headRefOid)"' 2>/dev/null </dev/null)
      [[ -z "$prs" ]] && continue

      for pr in ${(f)prs}; do
        pr_number=${pr%% *} pr_oid=${pr#* }
        if [[ "$tip" == "$pr_oid" ]] || git merge-base --is-ancestor "$tip" "$pr_oid" 2>/dev/null; then
          git branch -D "$branch" >/dev/null && echo "Deleted branch $branch (merged via PR #$pr_number)"
          continue 2
        fi
      done

      echo "Skipping $branch (has commits not in merged PR #${${prs%% *}})"
    fi
  done
}

# ------------------------------
# GitHub
# ------------------------------

alias gprv='gh pr view --web'

# ------------------------------
# GitHub CI Status
# ------------------------------

# Check CI status for the current branch
# Usage: gci
gci() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -z "$branch" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Check if there's a PR for this branch
  local pr_number=$(gh pr view --json number -q '.number' 2>/dev/null)

  if [[ -n "$pr_number" ]]; then
    gh pr checks
  else
    # No PR, check status on the latest commit
    echo "No PR found for branch: $branch"
    echo "Checking status for HEAD commit..."
    echo ""
    gh api "repos/{owner}/{repo}/commits/$(git rev-parse HEAD)/status" \
      --jq '"State: \(.state)\n", (.statuses[] | "  \(.context): \(.state) - \(.target_url)")'
  fi
}
