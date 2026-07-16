---
description: Generate my standup update or Friday weekly summary from briefs and logs
---

# /standup — Standup Reporter

Read-only: this reports from logs and briefs; recording what happened is /log's job.
If daily vs weekly is unclear, ask via one multi-choice message.

1. Pick the window's files free via terminal (`find .agent/design-logs .agent/briefs
   -mtime -1` daily / `-mtime -7` weekly — no generation), then read only the impl
   logs (`**Type:** IMPL`, skim Description headers first) and touched briefs.
2. **Daily** — output under 60 words:
   - Yesterday: shipped/progressed, concrete + past tense ("finished X, verified with Y")
   - Today: 1-2 items tied to tasks (never "continue working")
   - Blockers: apply the phrasing rules below, or "none"
3. **Weekly** — output:
   Shipped (one line each, with proof) / In progress (% + what's left) / Learned (1-2
   items from the logs' "What I learned") / Fix-cycle count this week / Next week (top 2
   priorities as I understand them — so my boss can correct my aim early).
4. **Blocker phrasing rules (mandatory):**
   - Never a bare "stuck on X".
   - Either: "For X I see options A or B, I lean A because… — do you have context that
     changes this?" or: "X is waiting on <thing> since <date>; meanwhile progressing on Y."
   - Every blocker carries an owner, an age, and a proposed way forward.
5. Tone: concrete beats busy; no hedging ("kind of works"); never inflate — the logs
   make honest claims provable.
