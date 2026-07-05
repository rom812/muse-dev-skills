---
name: feature-brief
description: 'Turn a vague task into a one-page feature brief BEFORE any coding — restate the problem, map affected services, define acceptance criteria, and generate smart clarifying questions for the boss. Use when receiving any new task, feature request, or bug assignment.'
---

# Feature Brief

The Stop & Understand protocol. Its whole purpose: **replace "start coding and fix forever"
with "understand for 20 minutes, then code once."**

## When this triggers

- The user got a new task/feature/bug from their boss and pastes or describes it.
- The user says "Danny asked me to…", "I need to implement…", "new ticket…".
- The user invokes `/feature-brief`.

Skip only for trivial mechanical changes (typo, rename, config value) — and say you're skipping.

## Hard rule

**No implementation code is written until the brief file exists and its Understanding
Check passes.** If the user pushes to code first, remind them once why the brief exists
(their own fix-loop history), then follow their decision.

## Protocol

### Step 1 — Capture the raw task

Record the task exactly as given (paste from chat/Jira). Ambiguity in the raw text is
*evidence* — it becomes the questions in Step 4.

### Step 2 — Restate in own words (Feynman gate)

Ask the user to state, in 2-3 of their own sentences (no copying):
- What is broken or missing today? (current behavior)
- What should happen instead? (desired behavior)
- Who/what triggers it? (user action, topology event, scheduled job, chat message)

If the user cannot answer one of these, **that is the finding** — mark it `UNKNOWN` and
route it to Step 4 questions or to `/domain-tutor` if it's a domain-knowledge gap rather
than a requirements gap.

### Step 3 — Map the blast radius

Identify (with the user, or via repo/wiki search if available in this environment):
- Which services/classes/modules does this touch? (e.g., chatbot tool layer, topology
  reader, job/trigger engine, TTS/STT pipeline, report generator)
- What existing similar feature can be copied from? **Always look for a precedent first** —
  in an unfamiliar codebase, the nearest existing pattern is worth more than any generated code.
- What could this break? (the thing that shares code/data with it)

### Step 4 — Craft the questions (the career-critical step)

Produce 2-4 clarifying questions to send to the boss. Rules for each question:

1. **Never ask "how should I do this?"** — that reads as helpless.
2. **Ask with options + a leaning:** "I see two approaches: (A) …, (B) …. I lean A because
   …. Do you agree, or is there context I'm missing?"
3. **Ask about scope boundaries:** "Should this also handle X, or is that out of scope?"
4. **Ask about acceptance:** "To confirm I'll know it's done: when <trigger>, the system
   should <observable result>. Correct?"
5. Batch them in ONE message, ordered by importance. One good batched message per task
   looks thorough; five scattered pings look lost.

### Step 5 — Fill and save the brief

Write `.agent/briefs/NNN-<kebab-description>.md` from `assets/feature-brief-template.md`
(NNN = next sequential number). Status starts `[DRAFT]`, becomes `[READY]` when questions
are answered, `[DONE]` when shipped (link the impl-log).

### Step 6 — Understanding Check (gate before coding)

The user must be able to answer YES to all:
- [ ] I can explain the feature to a rubber duck without reading the ticket.
- [ ] I know which files I'll touch and what the change roughly looks like.
- [ ] I know how I'll prove it works (test plan exists in the brief).
- [ ] Open questions are sent to the boss OR consciously assumed (assumptions written down).

All yes → proceed to plan/generate (see `token-sniper` for spending credits wisely).
Any no → the gap goes to `/domain-tutor` (knowledge gap) or Step 4 (requirements gap).

## Output format

The persistent artifact is the brief file. In chat, output only: the brief's location,
the questions ready to copy-paste to the boss, and the Understanding Check result.

## Gotchas

- A brief with empty "Acceptance criteria" is not `[READY]` — that's the section that
  prevents the fix loop.
- Don't let the brief balloon past one page — it's a thinking tool, not documentation.
- If mid-implementation the understanding changes, update the brief (one line in
  "Deviations") — don't silently drift.
