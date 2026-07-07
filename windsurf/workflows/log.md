---
description: Record an implementation-log entry — what AI generated, what I verified, what I learned
---

# /log — Implementation Log

Target file: `.agent/logs/NNN-<same-name-as-brief>.md`. Create from scratch if missing
(link the brief, status `[IN PROGRESS]`). Keep entries telegraphic — 2 minutes max.

1. Ask me which of these just happened — as suggested-responses multi-choice, one
   message: (a) AI generated code, (b) something broke / fix cycle, (c) task shipped.
2. **(a) Generation entry** — add a row: prompt gist | what it generated | verified by
   (compile/test/trace/manual — named evidence, never "looks right") | trust level:
   `understood` / `mostly` / `⚠ magic`. Any `⚠ magic` → tell me to run /verify before commit.
   Also note roughly how many credits the generation cost.
3. **(b) Fix cycle** — add a row: what broke | root cause | which earlier assumption of
   mine was wrong. The wrong-assumption column is mandatory — it's the learning.
4. **(c) Shipped** — status `[SHIPPED]`; check acceptance criteria against the brief;
   fill "What I learned" (one honest paragraph) and "Reusable" (patterns/gotchas worth
   keeping — suggest promoting big ones to a /tutor knowledge note). Mark the brief `[DONE]`.
5. Read back what was recorded in 2 lines.
