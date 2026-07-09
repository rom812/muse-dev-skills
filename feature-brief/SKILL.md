---
name: feature-brief
description: 'Turn a vague task into a one-page feature brief BEFORE any coding — restate the problem, map affected services, define acceptance criteria, and generate smart clarifying questions for the boss. Use when receiving any new task, feature request, or bug assignment.'
allowed-tools: Read, Write, Edit, Grep, Glob, AskUserQuestion, WebSearch, WebFetch, mcp__tavily__tavily_search, mcp__exa__exa_search
---

# Feature Brief

The Stop & Understand protocol. Its whole purpose: **replace "start coding and fix forever"
with "understand for 20 minutes, then code once."**

## When this triggers

- The user got a new task/feature/bug from their boss and pastes or describes it.
- The user says "my boss asked me to…", "I need to implement…", "new ticket…".
- The user invokes `/feature-brief`.

## When this does not trigger

- Trivial mechanical changes (typo, rename, config value) — say you're skipping and do it directly.
- A task already covered by an existing `[READY]` brief — extend that brief instead of creating one.
- Pure explanation/learning questions with no implementation ask — answer directly, or route to `domain-tutor`.
- The approach itself is still undecided (an idea, several possible directions) → `brainstorm` first.
- Decomposing an already-briefed multi-file task into steps → `task-planner`.

## Required inputs

- The task **verbatim** (pasted from chat/Jira, not summarized) — ask for it first if missing.
- The project root (where `.agent/briefs/` lives).
- The user's own restatement: current behavior, desired behavior, trigger.

## Interactive questions rule

Whenever this skill asks the user something, batch ALL questions into ONE message and
use the environment's interactive question UI — `AskUserQuestion` in Claude Code,
**suggested-responses multi-choice in Windsurf Cascade** — so the user answers with one
click in the same turn instead of paying for another. Never end a turn on an open
free-text question when options can be offered.

## Workflow

### Step 1 — Capture the raw task

Record the task exactly as given. Ambiguity in the raw text is *evidence* — it becomes
the questions in Step 4.

### Step 2 — Restate in own words (Feynman gate)

Ask the user (interactive UI, one message) to state in 2-3 of their own sentences:
current behavior · desired behavior · trigger (user action, topology event, job, chat
message). Any blank = mark `UNKNOWN` → route to Step 4 (requirements gap) or
`domain-tutor` (knowledge gap).

### Step 3 — Map the blast radius

Identify with the user, or via repo/wiki search where available: services/classes
touched · **the nearest existing precedent to imitate** (always look first — the
nearest existing pattern is worth more than any generated code) · what could break.
Check `.agent/knowledge/codemaps/` first — if the touched area is unmapped and the
blast radius is unclear, a `code-cartographer` session on that one area pays for
itself immediately.

### Step 4 — Optional research sweep (2–5 min, skip silently if not useful)

If a web-search tool is available (**Exa MCP in Windsurf**, Tavily/WebSearch in Claude
Code) and the task involves a non-trivial pattern (a design, an integration, an
algorithm — not routine CRUD): run 1-2 searches for best practices and similar
implementations. Record 2-3 takeaways with links in brief §6 Plan. Search calls are
far cheaper than a wrong implementation.

### Step 5 — Craft the questions for the boss (the career-critical step)

Produce 2-4 clarifying questions. Rules: never "how should I do this?"; always options
plus a leaning ("I see A or B, I lean A because… — agree?"); one scope-boundary
question; one acceptance confirmation ("when <trigger>, the system should <observable
result> — correct?"). Batch into ONE copy-pasteable message, ordered by importance.

### Step 6 — Fill and save the brief

Write `.agent/briefs/NNN-<kebab-description>.md` from `assets/feature-brief-template.md`
(NNN = next sequential number). Status `[DRAFT]` → `[READY]` when questions are
answered → `[DONE]` when shipped (link the impl-log).

### Step 7 — Understanding Check (gate before coding)

Present as an interactive multi-choice checklist; all must be YES:
explain without reading the ticket · know which files change · know how to prove it
works · open questions sent or consciously assumed (written down).
Any NO → `domain-tutor` (knowledge gap) or Step 5 (requirements gap).
All YES → multi-file/multi-day tasks go to `task-planner`; small tasks go straight to
`token-sniper` with the brief's §6 plan.

## Decision gates

- **No implementation code until the brief exists and the Understanding Check passes.**
  If the user pushes to code first, remind once why the brief exists, then follow their decision.
- A brief with empty acceptance criteria is not `[READY]`.
- `UNKNOWN` in Step 2 must be routed before Step 6, not carried silently.
- The research sweep is optional — skip without comment when no tool is available or
  the task is routine.

## Output format

The persistent artifact is the brief file. In chat, output only: the brief's location,
the questions ready to copy-paste to the boss, and the Understanding Check result.

## Gotchas

- Don't let the brief balloon past one page — it's a thinking tool, not documentation.
- Don't start coding "while waiting for answers"; if you must move, touch only what no
  answer can change, and write the assumption in §7.
- If mid-implementation the understanding changes, update the brief (one line in
  Deviations) — don't silently drift.
- Don't turn the research sweep into a rabbit hole — 2 searches, 5 minutes, takeaways
  into the brief, done.

## Evaluation checklist

- [ ] Brief file saved at `.agent/briefs/NNN-*.md` with zero unfilled placeholders in §1–6?
- [ ] Task captured verbatim, not paraphrased?
- [ ] Questions batched into ONE message, each with options + a leaning?
- [ ] All user questions asked via the interactive UI, not free-text turn-enders?
- [ ] Acceptance criteria observable and testable?
- [ ] Understanding Check all-YES before any code was written?

## Assets

- `assets/feature-brief-template.md` — the canonical brief structure; fill it, don't paste it into chat.
