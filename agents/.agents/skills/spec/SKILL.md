---
name: spec
description: "Turn a short task description into an agent-ready Linear ticket. Investigates the codebase, settles open decisions via clarifying questions, and files a ticket a fresh agent with no shared context can execute unassisted."
---

## What this does

The user invokes this with a task description as arguments, e.g. `/spec add rate limiting to the public API endpoints`. You turn that into a Linear ticket and file it. You are producing a _spec_, not the implementation — do not write or edit application code. The deliverable is the ticket.

## The governing rule

**Write for an executor who has none of this conversation.** The ticket will be picked up later by a fresh agent (or engineer) whose entire input is the ticket body — they cannot see this thread, your reasoning, or the decisions you and the user just made. Everything they need to act lives in the ticket or it is lost.

This single rule generates every concrete requirement below. When unsure whether to include something, ask: _"Would a cold-start executor be blocked without this?"_ If yes, it goes in the ticket.

A ticket fails this rule when it says things like _"implement the approach we discussed"_, _"add the telemetry event"_, or _"update the relevant module"_ — these only mean something to a reader who was here. It passes when it names the exact file to create, the existing module to mirror, and the decision that was already made and why.

> Vague (assumes context): "Add a failure event and wire it up."
> Agent-ready (assumes amnesia): "Create `lib/foo/events/bar.ex` implementing the `Baz` behaviour, mirroring `lib/foo/events/qux.ex:1`. Register it in `lib/foo/events.ex` by appending to `@event_types`."

## Operating principles

Each of these exists to correct a default failure mode. They are the load-bearing part of this skill.

- **Spec from evidence, not memory.** Do not write a plausible-sounding ticket from what you already know — that's how invented functions and wrong file paths get in. Open the code. Every claim in the ticket (a file path, a field, a function, current behavior) must be something you verified, not assumed.
- **Verify, don't ask.** Anything the codebase can answer, you answer yourself — exact paths, line numbers, whether a field/function exists, what the current behavior is, what pattern to mirror. Burning a user question on something a `grep` would settle is the most common way this skill annoys people.
- **Ask only genuine forks — but always ask those.** The test: _Can the code answer it?_ → go read. _Is there a conventional default?_ → take it, state it in the ticket. _Is it a real fork with no default and material consequences?_ → ask. Miscalibrating in either direction is a failure: interrogating the user about answerable things, or silently guessing on a real decision. Examples of real forks: replace-vs-keep an existing mechanism, whether data is sensitive to expose, a cost/volume tradeoff, where a policy threshold should live, filing logistics.
- **Record every decision where it will be read.** Each choice you or the user makes goes into a **Settled decisions** block in the ticket, as an imperative with its one-line rationale. The executor must never have to re-derive a call you already made.
- **Mirror existing conventions.** Find the closest existing module/pattern and point the implementer at it by name and line. Follow the repo's documented conventions (e.g. `AGENTS.md` or `CLAUDE.md`) and the idioms of the surrounding code.
- **Reference precisely.** Cite code as `path/to/file.ext:line` — clickable, and it saves the implementer a search.
- **Author as the user.** Write in the user's voice. Never add AI/agent attribution anywhere.

## Calibration

- **Scale the investigation to the task.** A one-line config change needs a paragraph and one file reference; a new subsystem needs parallel investigation and sample code. Don't turn a trivial task into a research project, and don't under-spec a deep one.
- **Surface a bad premise instead of speccing it faithfully.** If investigation shows the task rests on a false assumption, is already done, or has a materially better approach, stop and tell the user — don't write a tidy ticket for the wrong thing.

## Process

### 1. Understand the task

Parse the description. Identify the subsystem(s) and what "done" means. If it's too vague to even know where to look, ask one tight clarifying question — but usually investigation resolves the ambiguity.

### 2. Investigate (evidence-gathering)

Fan out **subagents** to explore concurrently (a read-only explorer agent for broad sweeps) so the main thread stays lean — this is for speed, not correctness. Typical parallel threads:

- **Current behavior** — where it lives today, exact call sites, what data is available at each, how it's surfaced.
- **Target pattern** — the system the work plugs into, the canonical module to copy, registration/wiring points, config.
- **Schema / data facts** — fields, types, whether referenced fields/associations exist, constraints.

Then **verify the load-bearing specifics yourself** with direct `Read`/`grep` so every claim the ticket makes is checked, not relayed on faith.

### 3. Identify the Linear destination

If the Linear MCP tools aren't loaded, load them (e.g. `ToolSearch` with `select:mcp__claude_ai_Linear__list_teams,mcp__claude_ai_Linear__save_issue,mcp__claude_ai_Linear__list_issues`, adding others as needed).

- Determine the target team with `list_teams`. One obvious team → use it; otherwise ask.
- Decide project, assignee, priority. If not obvious, fold these into the batched questions in step 4. Default assignee: ask, or "me" if the user already signaled it.

### 4. Settle open decisions (one batched round)

List the genuine open forks (per the ask-test) plus any filing logistics, and ask them in a **single `AskUserQuestion` batch** (up to 4):

- Each as a concrete either/or with real tradeoffs in the option descriptions.
- Recommended option first, append "(Recommended)" when you have a clear lean; stay neutral when it's genuinely the user's call.
- Don't ask what you can verify, and don't ask "is this ready?" questions.

If everything is already determined, skip straight to filing — but that's rare; most real tasks have 1–3 genuine forks.

### 5. Write, self-check, then file

Build the ticket in the structure below. Then run the **pre-file self-check** before calling `save_issue`.

File with `mcp__claude_ai_Linear__save_issue` (team + title + description + assignee/labels per the user's choices). Pass markdown with **literal newlines**, not escaped `\n`.

#### Ticket structure

Every ticket must satisfy these invariants — the cues made concrete: **decisions recorded, current state evidenced, work made concrete and ordered, done made testable, references precise.**

The sections below are the default layout for a change-behavior task. Drop one that genuinely doesn't apply; add one a task needs (Repro, Open questions, Rollout); collapse hard for trivial tasks. Drop only when it doesn't apply — never to save effort.

- **Summary** — what and _why_, in 2–4 sentences. Frame the problem, not just the change.
- **Settled decisions (agent-ready)** — numbered imperatives capturing every choice made, each with its rationale. Removes ambiguity.
- **Current behavior** — how it works today, with a code excerpt and `file:line` refs, plus any architecture context the implementer needs.
- **Target implementation** — concrete, ordered steps. Sample code following the canonical pattern. Exact files to create/modify and the wiring/registration points. Per-call-site details called out.
- **Acceptance criteria** — a `- [ ]` checklist that is specific and testable, including the test approach and any post-deploy verification.
- **Out of scope / follow-ups** — what you're deliberately not doing, and where it's tracked.
- **Key references** — annotated `file:line` anchors and external links (related tickets, docs).

#### Pre-file self-check (the gate)

Before filing, read the draft as the cold-start executor and confirm:

- [ ] Could a fresh agent execute this with **zero input but the ticket**? Any step that requires knowing something only said in this thread is a defect — fix it.
- [ ] Every file path, field, and function named in the ticket was **verified against the code**, not assumed.
- [ ] Every decision made during this session appears in **Settled decisions** — none left implicit.
- [ ] The implementer is pointed at a **named canonical example** to mirror (not just told what to build).
- [ ] Acceptance criteria are **testable**, not aspirational.

If any box fails, fix the ticket before filing.

### 6. Handle follow-ups (ask first)

If investigation surfaced out-of-scope work (a dependency, a restore step, a cleanup), list it under **Out of scope**, then **ask the user whether to file linked sibling tickets** before creating any. On yes, create each and link with `relatedTo: ["<issue-id>"]`, cross-referencing both bodies. Default to _asking_ — never auto-create.

### 7. Report and invite refinement

Summarize what you filed (IDs + links + the key settled decisions). Invite the user to push further — surface more open decisions, tighten a section, adjust filing — until it's agent-ready. When they propose a design change, fold it back through Settled decisions and any dependent tickets (keep linked tickets consistent — e.g. if a threshold changes, update the query that depends on it).

## Notes

- Labels only stick if they already exist in the workspace; if a requested label is unknown, file without it and say so.
- Linear may render `relatedTo` as a plain relation rather than blocks/blocked-by — offer the formal blocking link if dependency ordering matters.
