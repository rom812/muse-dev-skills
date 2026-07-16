---
description: Record an implementation-log entry — what AI generated, what I verified, what I learned
---

# /log — Implementation Log

Target file: `.agent/design-logs/NNN-<kebab-task-name>.md` — impl logs live in the SAME
folder and numbering sequence as the design logs. Keep entries telegraphic — 2 minutes max.
This records events; reporting status to humans is /standup's job (it reads these logs).

**On creation (log doesn't exist yet):**
- NNN = next sequential number: read `.agent/design-logs/INDEX.md` + existing filenames,
  take max + 1. Do NOT reuse the brief's number — link the brief in the header instead.
- Start the file with the low-token search header (same idea as the design logs — a
  future session reads ONLY the first ~10 lines to decide relevance):
  title, `**Type:** IMPL`, status `[IN PROGRESS]`, date, brief link, then a
  `## Description` section: 2-4 self-contained lines (what the task is, which
  services/classes it touches, expected outcome) + a `**Keywords:**` line of grep bait
  (feature name, class names, endpoints, error strings).
- Append a row to `.agent/design-logs/INDEX.md` following the table format already in
  that file (don't invent new columns); mark it as an impl log (e.g. `IMPL` in the
  type/title cell) with status + the same one-line description. If INDEX.md doesn't
  exist yet, create it — one row per EXISTING log too (backfill from their headers):
  `| NNN | Title (link) | Type (DESIGN/IMPL) | Status | One-line description |`.

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
5. **Every status change** (created / `[SHIPPED]` / `[ABANDONED]`) must also update the
   log's row in `.agent/design-logs/INDEX.md` — a log the INDEX doesn't know about
   doesn't exist.
6. Read back what was recorded in 2 lines.
