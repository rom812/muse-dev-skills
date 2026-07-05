---
name: impl-log
description: 'Keep a persistent log of every implementation: what the AI generated, what was verified and how, what broke, what was learned. Use when starting implementation of a briefed task, after AI generates code, or when finishing/shipping a task.'
---

# Implementation Log

A lightweight adaptation of the design-log methodology (LiozShor/claude-code-skills →
Yoav Abrahami) for a junior developer harnessing AI: **every AI-assisted implementation
leaves a written trace of what was generated, what was verified, and what was learned.**

Three payoffs:
1. **Anti-fix-loop:** writing "what I verified" catches the unverified assumption *before* it ships.
2. **Evidence file:** three months of logs = an undeniable record of shipped work and growth
   (performance reviews, "what have you been doing" moments).
3. **Prompt fuel:** logs record what worked, so future prompts and standups write themselves.

## When this triggers

- Implementation starts on a briefed task → create the log.
- AI generated code at work → record the generation entry.
- Task ships or a fix cycle happens → update the log.
- User invokes `/impl-log`.

## The log lifecycle

`.agent/logs/NNN-<same-name-as-brief>.md` — same NNN as the brief; statuses:

`[IN PROGRESS]` → `[NEEDS TESTING]` → `[SHIPPED]` (or `[ABANDONED]` with a why).

## Protocol

### On creation
Copy `assets/impl-log-template.md`, link the brief, status `[IN PROGRESS]`.

### After each AI generation (the core habit)
Add a generation entry — 4 lines, 2 minutes, non-negotiable:
- **Prompt (gist):** what was asked for
- **Got:** what it generated (files/approach), and whether it matched the plan in the brief
- **Verified by:** compile/test/trace/manual — *named evidence*, not "looks right"
- **Trust level:** `understood` / `mostly` / `⚠ magic` — anything `⚠ magic` MUST go through
  `/explain-before-merge` before commit

### The decision record (filled during /explain-before-merge, Gate 5)

The log's "Decision record" table (choice / alternatives considered / why this one) is
NOT filled here — it's filled while walking the final diff in `/explain-before-merge`,
one row per non-obvious choice. It exists in this file because the log is where you'll
re-read it: it is your prepared answer to the reviewer's "why did you implement it
like that?". A log with an empty decision table and status `[SHIPPED]` means the
verify gate was skipped.

### On every fix cycle
One line per fix: what broke, root cause, and **which earlier assumption was wrong**.
The wrong-assumption column is the entire point — patterns in it show what to check
earlier next time (that's how the fix count drops month over month).

### On shipping
- Status → `[SHIPPED]`, check acceptance criteria off against the brief.
- Fill **"What I learned"** (one honest paragraph) and **"Reusable"** (any pattern/snippet/
  gotcha worth remembering — promote big ones to a `/domain-tutor` knowledge note).
- Update the brief status to `[DONE]`.

## Rules

- **Never skip "Verified by".** An empty verification field means the code isn't done.
- **Log fixes without shame.** The log is private; its honesty is what makes the
  improvement visible later.
- **Keep entries telegraphic.** This must cost 2 minutes, not 20, or it dies.
- Logs live in the work project's `.agent/` (local-only via `.git/info/exclude`), never
  in a personal repo.

## Output format

Persistent artifact: the log file. In chat: confirm what was recorded and surface any
`⚠ magic` entries that still need `/explain-before-merge`.
