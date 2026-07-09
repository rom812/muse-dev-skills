---
name: impl-log
description: 'Keep a persistent log of every implementation: what the AI generated, what was verified and how, what broke, what was learned. Use when starting implementation of a briefed task, after AI generates code, or when finishing/shipping a task.'
allowed-tools: Read, Write, Edit, Grep, Glob, AskUserQuestion
---

# Implementation Log

A lightweight adaptation of the design-log methodology (LiozShor/claude-code-skills →
Yoav Abrahami) for a junior developer harnessing AI: **every AI-assisted implementation
leaves a written trace of what was generated, what was verified, and what was learned.**

Three payoffs: (1) anti-fix-loop — writing "what I verified" catches the unverified
assumption before it ships; (2) evidence file — months of logs are an undeniable record
of shipped work and growth; (3) prompt fuel — logs record what worked, so future
prompts and standups write themselves.

## When this triggers

- Implementation starts on a briefed task → create the log.
- AI generated code → record a generation entry.
- Something broke, or the task ships → record the fix cycle / close the log.
- The user invokes `/impl-log`.

## When this does not trigger

- Planning before implementation → `feature-brief`.
- The pre-commit verification walk itself → `explain-before-merge` (it writes back
  into this log, but the gates live there).
- Composing updates from the logs → `standup-reporter`.

## Required inputs

- Which event just happened: generation / fix cycle / shipped (ask via interactive
  multi-choice — `AskUserQuestion` in Claude Code, suggested responses in Cascade —
  one message, one click).
- The linked brief (its own number — the log gets a NEW number from the design-log sequence).
- For generations: prompt gist, what was produced, verification evidence, trust level.

## The log lifecycle

`.agent/design-logs/NNN-<kebab-task-name>.md` — impl logs live in the SAME folder,
numbering sequence, and INDEX.md as the design logs (one searchable history, not two).
Statuses: `[IN PROGRESS]` → `[NEEDS TESTING]` → `[SHIPPED]` (or `[ABANDONED]` with a why).

## Workflow

### On creation
- NNN = next sequential number in the shared sequence: read
  `.agent/design-logs/INDEX.md` + existing filenames, take max + 1. Do NOT reuse the
  brief's number — the brief is linked in the header instead.
- Copy `assets/impl-log-template.md`, link the brief, status `[IN PROGRESS]`.
- Fill the low-token search header (title, `**Type:** IMPL`, status, date, brief link)
  and the `## Description` section: 2-4 self-contained lines + a `**Keywords:**` grep-bait
  line — same idea as the design logs; a future session reads only the first ~10 lines
  to decide relevance.
- Append a row to `.agent/design-logs/INDEX.md` following the table format already in
  that file (don't invent new columns); mark it as an impl log (e.g. `IMPL` in the
  type/title cell) with status + the same one-line description. If INDEX.md doesn't
  exist yet, create it — one row per EXISTING log too (backfill from their headers):
  `| NNN | Title (link) | Type (DESIGN/IMPL) | Status | One-line description |`.

### After each AI generation (the core habit — 4 lines, 2 minutes)
- **Prompt (gist):** what was asked (reference the plan step, e.g. "plan step 3",
  when a `task-planner` plan exists) · **Got:** what it generated, matched the plan?
- **Verified by:** compile/test/trace/manual — *named evidence*, never "looks right"
- **Trust level:** `understood` / `mostly` / `⚠ magic`
- Optionally: rough credit cost of the generation.

### The decision record (filled during explain-before-merge, Gate 5)
The log's decision table (choice / alternatives considered / why this one) is filled
while walking the final diff in `explain-before-merge` — one row per non-obvious
choice. It lives here because this is where you re-read it: it is your prepared answer
to the reviewer's "why did you implement it like that?".

### On every fix cycle
One line: what broke · root cause · **which earlier assumption was wrong** (the only
column that matters — patterns in it show what to check earlier next time).

### On shipping
Status → `[SHIPPED]`; check acceptance criteria against the brief; fill "What I
learned" (one honest paragraph) and "Reusable" (promote big items to a `domain-tutor`
knowledge note); mark the brief `[DONE]`.

### On every status change
Update the log's row in `.agent/design-logs/INDEX.md` (created / `[SHIPPED]` /
`[ABANDONED]`) — a log the INDEX doesn't know about doesn't exist.

## Decision gates

- Never record a generation without a filled "Verified by" — empty verification means
  the code isn't done.
- Any `⚠ magic` entry MUST pass through `explain-before-merge` before commit.
- A log marked `[SHIPPED]` with an empty decision table means the verify gate was
  skipped — flag it, don't close it.

## Output format

Persistent artifact: the log file. In chat: confirm what was recorded in 2 lines and
surface any `⚠ magic` entries still needing `explain-before-merge`.

## Gotchas

- Keep entries telegraphic — an entry that takes >2 minutes kills the habit by Thursday.
- Log fixes without shame; the log is private and its honesty is what makes improvement
  visible later.
- Logs live in the work project's `.agent/` (local-only via `.git/info/exclude`),
  never in a personal repo.
- Never write to a separate `.agent/logs/` folder — that fragments the history. One
  folder (`design-logs/`), one INDEX, one number sequence shared with the design logs.

## Evaluation checklist

- [ ] Log created in `.agent/design-logs/` with the next sequential number from INDEX.md
      (not the brief's number), brief linked in the header?
- [ ] Header has `**Type:** IMPL`, a filled `## Description` (2-4 lines), and a
      `**Keywords:**` line — relevance decidable from the first ~10 lines alone?
- [ ] INDEX.md row appended on creation and updated on every status change, matching
      the existing table format?
- [ ] Every generation row has named verification evidence and a trust level?
- [ ] Fix-cycle rows include the wrong-assumption column?
- [ ] The which-event question was asked via interactive UI, one message?
- [ ] On ship: acceptance criteria checked, "What I learned" filled, brief marked `[DONE]`?

## Assets

- `assets/impl-log-template.md` — the log structure (search header + description,
  generations, decision record, fix cycles, shipped, learned, reusable).
