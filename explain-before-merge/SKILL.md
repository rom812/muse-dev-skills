---
name: explain-before-merge
description: 'Verification gate for AI-generated code before commit: explain every changed line, trace the runtime flow, hunt edge cases, and produce a PR description with a real test plan. Use before committing any AI-assisted change.'
---

# Explain Before Merge

The hard gate that ends the "commit AI code → it breaks → fix → looks bad" cycle.
Core rule: **treat AI output like code from a stranger — if you can't explain a line,
you can't commit it.** Plausible-looking is exactly where the subtle bugs hide.

## When this triggers

- An AI-assisted change is about to be committed.
- An impl-log has a `⚠ magic` generation entry.
- The user invokes `/explain-before-merge` or `/verify`.

## When this does not trigger

- Pre-implementation understanding → `feature-brief`.
- Logging what happened → `impl-log` (this skill writes into it, but rows are its job).
- Reviewing someone ELSE's PR — the gates assume the user authored (or AI-authored) the diff.
- Rehearsing a live demo or walkthrough → `demo-prep` — this gate produces the PR;
  that one prepares the room (its step 6 calls back here for the diff).

## Required inputs

- The final diff (run on the whole change, not per-file — the runtime trace needs it).
- The task's brief (for intent and acceptance criteria) and impl-log (to update).
- Build/test commands for the project.

## Interactive questions rule

When walking gates with the user, ask via the interactive question UI (`AskUserQuestion`
in Claude Code, suggested-responses multi-choice in Cascade), batching per gate — e.g.
hunk verdicts as options (Explained / Can't explain / Wrong), checklist items as
multi-select. Never end a turn on an open free-text question when options can be offered.

## Workflow

### Gate 1 — Line accountability
Walk the diff hunk by hunk; the user states what each does and why. Outcomes:
**Explained** → passes · **Can't explain** → AI explains, user restates in own words;
still unclear → simplify the code until it IS explainable · **Wrong/unneeded** → gate
caught a bug; fix and log the fix cycle.

### Gate 2 — Runtime trace
Trace ONE real scenario end-to-end through the new code naming actual methods
(chat message or topology event in → tool selection → tool execution → response into
the UI). Slow down at async boundaries — that's where the bugs live.

### Gate 3 — Edge-case hunt (stack-specific classics AI omits)
- Nulls/empties; missing Optional handling
- Error paths: downstream/tool throws → swallowed? user-facing message vs stack trace?
- Concurrency: mutable state in singleton beans; `@Async` + request-scoped data
- `@Transactional` on the right layer; self-invocation proxy trap
- Resources: unclosed clients; missing timeouts (LLM calls especially)
- Config: hardcoded values that belong in `application.yml`
- **Vaadin threading (this project's #1 trap):** components touched from async/AI
  completions must be inside `ui.access(...)` with `@Push` enabled and a
  `ui.isAttached()` guard; conversation state in `@UIScope`/session-scoped beans,
  never singleton fields (vaadin-mentor §2, §4, §7).

### Gate 4 — Test plan executed (not just written)
Map the change to the brief's acceptance criteria; prove each via unit test,
integration test, or a manual check *actually performed now*. Run the build + existing
tests; paste results into the impl-log's "Verified by".

### Gate 5 — Review defense (the "why did you implement it like that?" rehearsal)
1. Fill the impl-log's decision table: choice / alternatives / why this one. If the AI
   chose, ask it for alternatives + rationale, verify against the code, restate in own
   words. An unverifiable rationale means the choice needs re-examining, not memorizing.
2. Predict the 3 diff lines a reviewer will question; say the answers out loud once.
3. Honest fallback for anything undefendable: "I followed the pattern from
   `<precedent>`; let me double-check that choice and get back to you today" — then do.
   NEVER answer "the AI did it that way."

## Decision gates

- Gates run in order; a failed gate loops back before proceeding.
- If Gate 1 leaves any hunk unexplainable after simplification attempts, the change
  does not get committed.
- If tests fail in Gate 4, stop and log the fix cycle — do not "commit and fix later".
- Run `corrections-ledger check` against the diff before the PR goes out. A repeat of a
  correction you were already given, found by the reviewer, costs more credibility than
  any bug these gates catch.
- If it never stops you, you're not running it honestly.

## Output format

Ready-to-paste PR description:
**What** (1-2 sentences) · **Why** (from the brief) · **How** (3 bullets incl. which
precedent it follows) · **How I tested** (checked boxes, concrete) · **Notes for
reviewer** (the one place deserving extra eyes, stated honestly).
Plus: impl-log updated (`⚠ magic` → `understood`, decision rows, fix cycles).

## Gotchas

- Reading silently doesn't count in Gate 1 — explain out loud; your eyes skip what
  your mouth can't say.
- "Compiles and looks clean" is not verification — run the real flow (dangerous AI
  mistakes are code that runs but does the wrong thing).
- 15 minutes here is cheaper than one broken merge — in time and in reputation.

## Evaluation checklist

- [ ] Every hunk explained (or simplified until explainable)?
- [ ] One end-to-end trace done naming real methods?
- [ ] Stack-specific edge cases checked, including Vaadin threading and LLM timeouts?
- [ ] Each acceptance criterion proven by an executed check, results in the impl-log?
- [ ] Decision table filled; top-3 reviewer questions rehearsed?
- [ ] PR description produced with a concrete "How I tested"?
