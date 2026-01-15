# ------------------------------
# Git Worktrees
# ------------------------------

# Add a worktree as a sibling directory with branch name suffix
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

  git worktree add "$worktree_path" "$branch"
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
