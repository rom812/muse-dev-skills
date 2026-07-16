---
description: Decompose a READY brief into one-shot-sized implementation steps with GEN/HAND/FREE tags
---

# /plan — brief → generation schedule

Only for multi-file or multi-day tasks with a [READY] brief. No brief → /brief first.
Approach undecided → /brainstorm. Single-file same-day task → the brief's §6 is enough.
Ask me everything via suggested-responses multi-choice, batched per decision.

1. Open the brief; verify it's [READY] (questions answered, acceptance criteria
   filled). Holes → stop, back to /brief.
2. Slice into steps where EACH step fits one prepared generation or ≤30 min by hand:
   - Files: exact create/modify paths
   - What: one sentence
   - Precedent: the file/pattern to imitate (mandatory where one exists)
   - Prove it: the test/check that shows the step worked
   Order steps so the build stays green after every one.
3. Tag each step: [GEN] worth an AI generation (prepare via the one-shot template in
   `.agent/reference/weak-model-playbook.md`) ·
   [HAND] faster by hand / copy-precedent · [FREE] config/wiring/renames.
   This tagging is where my credit budget gets decided.
4. Risks: top 2-3 with mitigations + what to check before merge + rollback note.
5. Save .agent/plans/NNN-<same-name-as-brief>.md; link it from the brief §6 and the
   impl-log. More than ~10 steps → propose splitting the task and draft the
   options-plus-leaning message for my boss.
Gate: a step without a "Prove it" check isn't a step — split or clarify. Deviations
during implementation go to the impl-log, never silent plan rewrites.
