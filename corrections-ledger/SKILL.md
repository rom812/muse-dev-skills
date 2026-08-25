---
name: corrections-ledger
description: 'Record every correction, review comment, or "you should have known that" into one durable ledger, extract the reusable rule from it, and consult the ledger before every PR, demo, and generation. Use when anyone corrects you, when preparing a PR or demo, or when the same mistake feels familiar.'
argument-hint: "[add | check | review]"
---

# Corrections Ledger

The mechanism behind one rule: **never be told the same thing twice.**

Seniors do not grade a junior on knowing everything. They grade on whether feedback
sticks. One repeated correction costs more credibility than five first-time mistakes,
because the first is inexperience and the second is inattention.

This skill is also the durable replacement for agent memory. Devin Local does not
persist memories between sessions, so a corrections file in the repo is the only thing
that survives — and unlike a memory, it survives a laptop, a reinstall, and a job.

## When this triggers

- Anyone corrects you: boss, reviewer, PR comment, demo remark, Teams message.
- You are about to open a PR, run a demo, or request a review → consult mode.
- You are about to generate code in an area that has burned you before.
- The user invokes `/ledger`.

## When this does not trigger

- A correction that is really a new requirement → that is scope, log it via `impl-log`
  and (if it changes the task) `feature-brief`.
- Something you got wrong and nobody caught → that is a fix cycle, `impl-log` owns it.
- A domain concept you did not understand → `domain-tutor` writes the note; only the
  *lesson about your process* comes here.

## Required inputs

Ask in ONE message with multi-choice options:

- Mode: `add` a correction / `check` the current change against the ledger / `review`
  the patterns.
- For `add`: who corrected you, what you did, what they said. Everything else is derived.

## The ledger

`.agent/knowledge/corrections.md` — one file, append-only, newest at the top so the
most recent lessons are read first when the file gets long.

Each entry is five fields and takes ninety seconds:

| Field | Content |
|---|---|
| **Date + who** | `2026-07-24 · Danny (PR comment)` |
| **What I did** | The concrete thing, one line. |
| **What they said** | Their words, quoted where possible — not your paraphrase. |
| **The rule** | The generalised lesson. This is the only field that has future value. |
| **Applies when** | The trigger condition that should make you recall it. |

### Writing the rule field

The rule must generalise past the specific incident, or it will never fire again.
The test: could this rule have prevented a *different* mistake?

- ❌ "Use `EntityStatusConverter` for status strings." — fires once, never again.
- ✅ "Before writing any type-to-display conversion, grep for an existing
  `*Converter` / `*Mapper` / `*Formatter` in the UI module." — fires forever.
  (Run `precedent-check`, which exists for exactly this.)

## Workflow

### `add` — after any correction
1. Capture the five fields. Do not editorialise and do not apologise in the file.
2. **Repeat check:** scan existing rules for a semantic match. A match means this
   lesson already existed and did not fire — mark the entry `⚠ REPEAT` and escalate
   it in step 3. This is the signal the whole ledger exists to produce.
3. **Promote:** if a rule has now fired twice, it stops being a note and becomes
   enforcement — add it to `.windsurf/rules/ai-discipline.md` (hard gates) or the
   relevant pattern reference, so the agent applies it without you remembering.
4. Confirm in two lines. Never more — the cost of an entry is what kills the habit.

### `check` — before a PR, demo, or review
1. Read every rule field in the ledger (rules only, skip the narrative).
2. Walk the current diff against them and report only actual hits: rule, the line it
   applies to, and the fix.
3. Explicitly say "no ledger hits" when there are none, so the check is visibly real
   rather than silently skipped.

### `review` — weekly, or before a 1:1
Group rules by theme and count them. Three or more rules in one theme is not three
mistakes, it is one missing habit — name that habit. Feed the honest version into
`standup-reporter` (growth evidence) and the pattern into `feature-brief`'s question
list, so the gap gets closed by asking rather than by being told.

## Decision gates

- No PR or demo without a `check` pass. This is the whole point of the ledger; an
  unconsulted ledger is a diary.
- A `⚠ REPEAT` entry blocks the "I'm done" claim until step 3's promotion is written.
- Never delete an entry. Superseded rules get struck through with a pointer to the
  rule that replaced them — the history is the growth evidence.

## Output format

Persistent artifact: `.agent/knowledge/corrections.md`.
In chat: for `add`, the extracted rule and whether it was a repeat. For `check`, hits
only. Never reprint the ledger.

## Gotchas

- The ledger is private, in the work project's `.agent/` (local-only via
  `.git/info/exclude`). Never push it to a personal repo.
- Write the entry the same day. A correction recalled on Friday has lost the exact
  wording, and the wording is where the rule hides.
- Resist writing rules that are really self-criticism ("be more careful"). Unfalsifiable
  and unactionable — if you cannot name the trigger condition, you do not have a rule yet.
- Do not let the ledger become a feelings journal. Five fields, ninety seconds.

## Evaluation checklist

- [ ] Entry has all five fields, with their words quoted rather than paraphrased?
- [ ] The rule generalises — would it catch a different mistake than the one that caused it?
- [ ] Repeat check run against existing rules, `⚠ REPEAT` applied where matched?
- [ ] Twice-fired rules promoted into `.windsurf/rules/` or a pattern reference?
- [ ] `check` mode run before the PR/demo, with hits or an explicit "no hits"?
- [ ] Newest entry at the top; nothing deleted, only struck through?

## Assets

- `assets/corrections-template.md` — the ledger file structure and a worked entry.
