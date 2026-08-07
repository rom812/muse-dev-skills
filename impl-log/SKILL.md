---
name: impl-log
description: 'Keep an indexed, per-feature log of every implementation under .agent/design-logs/<feature>/: what the AI generated, what was verified and how, what broke, what was learned. ALSO the context-recall protocol: before implementing any prompt, consult the log indexes for relevant prior context. Use when starting implementation of a briefed task, after AI generates code, when finishing/shipping a task, or before implementing in a repo that has design-logs.'
---

# Implementation Log

An adaptation of the design-log methodology (LiozShor/claude-code-skills → Yoav
Abrahami) for a junior developer harnessing AI: **every AI-assisted implementation
leaves a written trace of what was generated, what was verified, and what was
learned — organized per feature, indexed at two levels, and consulted BEFORE new
work starts.**

Three payoffs: (1) anti-fix-loop — writing "what I verified" catches the unverified
assumption before it ships; (2) agent memory — an agent that reads the feature index
first starts with months of accumulated decisions instead of a blank slate;
(3) evidence file — the logs are an undeniable record of shipped work and growth,
and prompt fuel for standups.

## Directory layout (the contract)

```
.agent/design-logs/
├── INDEX.md                     # GLOBAL index — one row per log, all features
├── research-index.md            # (owned by design-log, if present — don't touch)
└── <feature-slug>/              # e.g. voice-chat/, appointment-booking/
    ├── INDEX.md                 # FEATURE index — snapshot + this feature's logs
    └── NNN-<kebab-task>.md      # the logs themselves
```

- **Every log lives inside a feature directory.** Never write a log loose in
  `design-logs/` root. One directory per product feature, kebab-case English slug.
- **Reuse before create:** `ls .agent/design-logs/` first; if a directory for the
  feature exists under any close name, use it. Only create a new directory for a
  genuinely new feature (take the slug from the brief's feature name).
- **One number sequence, repo-wide:** NNN = max across global INDEX.md + all
  existing filenames (any subfolder, design or impl) + 1. Shared with design logs so
  the histories interleave chronologically. Never reuse the brief's number.

## Context recall — run BEFORE implementing anything

This half of the skill triggers on any implementation prompt in a repo that has
`.agent/design-logs/`, even when nobody says "impl-log". Cheap-first, three layers
(progressive disclosure — never bulk-read log bodies):

1. **Global INDEX.md** (one screen): scan for rows matching the task. Note candidate
   features and log numbers.
2. **Feature INDEX.md** of the matched feature(s): read the Snapshot — current
   state, decisions in force, active gotchas. This is the primer; often it is enough.
3. **Keyword grep** for cross-feature hits: derive 3-6 terms from the task (feature
   name, class/endpoint names, error strings) and `grep -ril` them across all log
   bodies. Recency is NOT relevance — do not substitute "read the last N logs".
4. Read only the **Description header** (first ~15 lines) of candidate logs; open a
   full body only when clearly relevant.
5. Record what you used: the new log's **Related logs** line cites every log that
   informed the work. State recalled decisions out loud before coding ("log 014
   chose @Async for LLM calls — following that precedent").

Budget: under a minute, a handful of file reads. If nothing matches, say so in one
line and move on — silence is how recall quietly dies.

**One-time wiring (do this once per work repo):** copy
`assets/agents-md-snippet.md` into the repo's `AGENTS.md` (create it if missing, or
append). Devin reads AGENTS.md automatically and Claude Code picks it up too, so
ANY agent — not just one running this skill — learns to check the indexes first. If
the team doesn't want AGENTS.md committed, put the snippet in a local rules file
(`.windsurf/rules/` or `CLAUDE.local.md`) instead.

## When this triggers

- Any implementation prompt in a repo with `.agent/design-logs/` → context recall.
- Implementation starts on a briefed task → create the log.
- AI generated code → record a generation entry.
- Something broke, or the task ships → record the fix cycle / close the log.
- The user invokes `/impl-log`.

## When this does not trigger

- Planning before implementation → `feature-brief`.
- The pre-commit verification walk itself → `explain-before-merge` (it writes back
  into this log, but the gates live there).
- Composing updates from the logs → `standup-reporter`.
- A correction someone else gave you → `corrections-ledger` — this log records what
  *you* found; the ledger records what *you were told*.

## Required inputs

- Which event just happened: recall / generation / fix cycle / shipped (interactive
  multi-choice — `AskUserQuestion` in Claude Code, numbered options in Devin — one
  message, one click).
- The linked brief and the feature slug (from the brief; confirm against existing
  directories).
- For generations: prompt gist, what was produced, verification evidence, trust level.

## The log lifecycle

`.agent/design-logs/<feature>/NNN-<kebab-task>.md`, statuses:
`[IN PROGRESS]` → `[NEEDS TESTING]` → `[SHIPPED]` (or `[ABANDONED]` with a why).

### On creation
- Resolve the feature directory (reuse-first rule above). If new: create it plus its
  `INDEX.md` from `assets/feature-index-template.md`.
- Take the next global NNN; copy `assets/impl-log-template.md`; link the brief;
  status `[IN PROGRESS]`.
- Fill the low-token search header: title, `**Type:** IMPL`, feature, status, date,
  brief link, Related logs (from context recall) — then `## Description`: 2-4
  self-contained lines + a `**Keywords:**` grep-bait line. A future session reads
  ONLY the first ~15 lines to decide relevance — write them for that reader.
- Append a row to BOTH indexes: the feature INDEX.md, and the global INDEX.md where
  the link path carries the feature (`| NNN | [Title](<feature>/NNN-….md) | IMPL |
  Status | one-liner |`). If the global INDEX.md doesn't exist, create it and
  backfill one row per existing log from their headers.

### After each AI generation (the core habit — 4 lines, 2 minutes)
- **Prompt (gist):** what was asked (reference the plan step when a `task-planner`
  plan exists) · **Got:** what it generated, matched the plan?
- **Verified by:** compile/test/trace/manual — *named evidence*, never "looks right"
- **Trust level:** `understood` / `mostly` / `⚠ magic`
- Optionally: rough credit cost of the generation.

### The decision record (filled during explain-before-merge, Gate 5)
The log's decision table (choice / alternatives considered / why this one) is filled
while walking the final diff in `explain-before-merge` — one row per non-obvious
choice. It is your prepared answer to "why did you implement it like that?", and it
is what context recall later surfaces as precedent.

### On every fix cycle
One line: what broke · root cause · **which earlier assumption was wrong** (the only
column that matters — patterns in it show what to check earlier next time).

### On shipping
Status → `[SHIPPED]`; check acceptance criteria against the brief; fill "What I
learned" and "Reusable" (promote big items to a `domain-tutor` knowledge note); mark
the brief `[DONE]`. Then **refresh the feature Snapshot** — current state, decisions
now in force, gotchas discovered — so the next agent's primer is current.

### On every status change
Update the log's row in BOTH indexes. A log the indexes don't know about doesn't
exist.

## Migrating a flat design-logs/ (one-time, offer when detected)

If impl logs sit loose as `.agent/design-logs/NNN-*.md`: group them by feature,
`git mv`/move each into its feature directory, create the feature INDEX.md files,
and rewrite the global INDEX.md links. Numbers never change — only paths. Leave any
design-log-owned files (research-index.md, current-status.md) untouched.

## Decision gates

- Never start implementing without the context-recall pass (or an explicit
  "no relevant logs" statement).
- Never record a generation without a filled "Verified by" — empty verification
  means the code isn't done.
- Any `⚠ magic` entry MUST pass through `explain-before-merge` before commit.
- A log marked `[SHIPPED]` with an empty decision table means the verify gate was
  skipped — flag it, don't close it.
- A ship without a Snapshot refresh leaves the feature index lying to the next
  agent — treat it as unfinished.

## Output format

Persistent artifacts: the log file + both INDEX.md rows (+ Snapshot on ship). In
chat: confirm what was recorded in 2 lines; on recall, list the logs consulted and
the decisions being followed; surface any `⚠ magic` entries still needing
`explain-before-merge`.

## Gotchas

- Keep entries telegraphic — an entry that takes >2 minutes kills the habit by
  Thursday.
- Log fixes without shame; the log is private and its honesty is what makes
  improvement visible later.
- Logs live in the work project's `.agent/` (local-only via `.git/info/exclude`),
  never in a personal repo. The AGENTS.md snippet is therefore conditional ("if the
  folder exists") so it stays harmless for teammates without logs.
- Don't fragment features: `voice-chat/` and `voice-chatbot/` side by side means
  recall misses half the history. `ls` first, reuse aggressively.
- Snapshot ≠ diary: keep it 3-8 lines of *current* truth, rewrite it, don't append.

## Evaluation checklist

- [ ] Context recall ran before implementation — indexes scanned, keywords grepped,
      consulted logs cited in Related logs (or "no relevant logs" stated)?
- [ ] Log created inside the correct feature directory with the next global NNN,
      brief linked?
- [ ] Header + Description + Keywords decidable from the first ~15 lines alone?
- [ ] Rows appended to BOTH the feature and global INDEX.md on creation, updated on
      every status change?
- [ ] Every generation row has named verification evidence and a trust level?
- [ ] Fix-cycle rows include the wrong-assumption column?
- [ ] On ship: acceptance criteria checked, "What I learned" filled, brief marked
      `[DONE]`, feature Snapshot refreshed?
- [ ] AGENTS.md snippet present in the work repo (one-time wiring)?

## Assets

- `assets/impl-log-template.md` — the log structure (search header + description,
  generations, decision record, fix cycles, shipped, learned, reusable).
- `assets/feature-index-template.md` — per-feature INDEX.md (Snapshot + log table).
- `assets/agents-md-snippet.md` — paste into the work repo's AGENTS.md so every
  agent (Devin, Claude Code, anything AGENTS.md-aware) runs context recall first.
