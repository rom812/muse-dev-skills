---
name: task-planner
description: 'Decompose a READY feature brief into an ordered implementation plan where every step is sized for ONE prepared AI generation or one short manual edit — files per step, test per step, risks. Use for multi-file or multi-day tasks after the brief is answered, before any code generation.'
---

# Task Planner

Adapted from the writing-plans discipline (superpowers) and Spec Kit's /plan phase,
fitted to a credit-limited workflow: **each plan step must be executable as ONE
token-sniper shot** (or one short manual edit), so the plan doubles as the generation
schedule. Plans assume the executor (a weak model, or tired-future-you) has zero
context and questionable taste — everything explicit.

## When this triggers

- A feature-brief is `[READY]` and the task spans multiple files or multiple days.
- The user asks "break this down" / "make a plan" for a briefed task.
- The user invokes `/task-planner` or `/plan`.

## When this does not trigger

- No brief exists yet → `feature-brief` (no planning on unvalidated understanding).
- The approach itself is undecided → `brainstorm`.
- Single-file, same-day task → the brief's own §6 Plan is enough; say so and stop.
- Preparing the individual generation prompt → `token-sniper` (consumes this plan).

## Required inputs

- The `[READY]` brief (acceptance criteria answered — verify, don't assume).
- The precedent file(s) identified in the brief's blast radius.
- Rough deadline (calibrates step count vs corner-cutting honesty).

## Interactive questions rule

Ask everything via the interactive UI (`AskUserQuestion` / Cascade suggested
responses), batched per decision — e.g. sequencing choices and risk tolerances as
multi-choice, one message each.

## Workflow

### Step 1 — Verify the brief is actually READY
Open it. Unanswered questions or empty acceptance criteria → back to `feature-brief`;
do not plan around holes.

### Step 2 — Slice into one-shot steps
Each step gets: **Files** (create/modify, exact paths) · **What** (one sentence) ·
**Precedent** (the file/pattern this step imitates — mandatory where one exists;
find it with `precedent-check`) ·
**Prove it** (the test or check that shows the step worked) · **Size check** (fits one
prepared generation or ≤30 min manual work; too big → split).
Order steps so each leaves the build green — no step depends on three future steps
landing.

### Step 3 — Mark the generation plan
Tag each step: `[GEN]` (worth an AI generation — prepared via `token-sniper`),
`[HAND]` (faster by hand / copy-precedent), `[FREE]` (config, wiring, renames).
This tagging is where the credit budget is actually decided.

### Step 4 — Risks and rollback
Top 2-3 risks with mitigations; what to check before merging (feeds
`explain-before-merge` Gate 3); how to back out if it breaks after merge.

### Step 5 — Save and sync
Write `.agent/plans/NNN-<same-name-as-brief>.md`; link it from the brief §6 and the
impl-log header. As implementation proceeds, tick steps off and note deviations in
the impl-log (not by rewriting the plan).

## Decision gates

- No plan without a `[READY]` brief — planning is decomposition, not discovery.
- A step that can't name its "Prove it" check isn't a step yet — split or clarify.
- If more than ~10 steps emerge, propose splitting the task itself and flag it to the
  boss (options + leaning) before committing to a mega-plan.
- Plans don't get silently rewritten mid-flight — deviations go to the impl-log.

## Output format

Persistent artifact: the plan file (header: goal, one-paragraph architecture, then
the numbered steps with tags). In chat: the step list with tags and the risk summary
— plus which step to start with and its `token-sniper` template suggestion.

## Gotchas

- Steps sized for a strong model are too big for the work models — when in doubt,
  split; two small prepared shots beat one confused big one.
- Don't plan implementation details the precedent already answers — "imitate X" beats
  restating X's contents.
- The `[GEN]/[HAND]/[FREE]` tags are the point: an untagged plan silently burns
  credits on steps that were faster by hand.
- A plan is also Copilot-bridge material — pasting it into the pack lets the strong
  model draft each step's prompt (bridge prompt #5).

## Evaluation checklist

- [ ] Brief verified `[READY]` before planning?
- [ ] Every step has files, precedent (where one exists), a "Prove it" check, and a size that fits one shot?
- [ ] Steps ordered to keep the build green throughout?
- [ ] Every step tagged `[GEN]`/`[HAND]`/`[FREE]`?
- [ ] Plan saved to `.agent/plans/` and linked from the brief and impl-log?
