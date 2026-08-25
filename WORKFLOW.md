# The Master Loop

Every task from your boss runs through the same loop. The loop exists because of one hard-won
lesson (yours): **starting to code before understanding the problem is what creates the endless
fix cycle and makes you look worse than you are.** Twenty minutes of structured understanding
up front replaces two days of flailing.

```
        TASK ARRIVES (from my boss / Jira / chat)
              │
              ▼
 ┌─ 1. UNDERSTAND ──────────────────────────────┐
 │  /feature-brief  → one-page brief             │
 │  Domain gap found? → /domain-tutor first      │
 │  Output: 2-4 smart questions for my boss      │◄─── This is where you WIN.
 │  ⛔ HARD GATE: no code before the brief is    │     Good questions early =
 │     filled and questions are answered.        │     competent. Fixes later =
 └──────────────┬───────────────────────────────┘     incompetent.
                ▼
 ┌─ 2. PLAN ────────────────────────────────────┐
 │  In the brief: files to touch, steps,         │
 │  acceptance criteria, test plan.              │
 │  Heavy thinking → Claude at home (abstract    │
 │  problem, no proprietary code).               │
 └──────────────┬───────────────────────────────┘
                ▼
 ┌─ 3. GENERATE (spend credits HERE, surgically)┐
 │  /token-sniper rules: one prepared prompt,    │
 │  full context, expected output format.        │
 │  NEVER type "doesn't work, fix it".           │
 └──────────────┬───────────────────────────────┘
                ▼
 ┌─ 4. VERIFY ──────────────────────────────────┐
 │  /explain-before-merge  +  /ledger check      │
 │  ⛔ HARD GATE: if you can't explain a line,   │
 │     you don't commit it.                      │
 │  ⛔ HARD GATE: no repeat of a past correction.│
 └──────────────┬───────────────────────────────┘
                ▼
 ┌─ 5. LOG ─────────────────────────────────────┐
 │  /impl-log → what was generated, what you     │
 │  verified, what you learned.                  │
 └──────────────┬───────────────────────────────┘
                ▼
 ┌─ 6. SHOW ────────────────────────────────────┐
 │  /demo-prep before any demo or review;        │
 │  /standup-reporter (daily + Friday wins).     │
 │  Every late ask captured with a date.         │
 └──────────────────────────────────────────────┘
```

## Four optional expansions of the loop

- **Before step 1**, when the approach itself is undecided (an idea, an open-ended ask):
  `/brainstorm` — one-question-at-a-time exploration → 2-3 alternatives → validated
  approach → feeds the brief (or becomes an options-plus-leaning proposal for my boss).
- **Between steps 2 and 3**, for multi-file/multi-day tasks: `/task-planner` (`/plan`
  in Windsurf) — the brief becomes one-shot-sized steps tagged `[GEN]`/`[HAND]`/`[FREE]`;
  each `[GEN]` step is exactly one prepared token-sniper shot.
- **Inside step 3, before every generation of shared code:** `/precedent-check`
  (`/precedent`) — a four-angle sweep for an existing util/converter/helper. It runs as a
  read-only subagent on the cheap model, so it costs almost nothing and prevents the most
  expensive-looking mistake available: shipping a second copy of something we already have.
- **Inside step 3, before every generation of a NEW FILE:** `/architecture-contract`
  (`/arch`) — precedent-check's twin. Where that one stops a second copy, this one stops
  code that is new, correct, and in the wrong place. `/arch map` once per area extracts the
  layers, dependency directions and canonical flows into a two-page contract your boss can
  correct in one pass; `/arch check` then verdicts each new file FITS / VIOLATES /
  **UNCOVERED**. That third verdict is the one that matters — it turns "I didn't know the AI
  was wrong" into a question you can actually ask. Confirmed clauses graduate to frozen
  ArchUnit tests via `/arch enforce`, so the build catches drift instead of you.

## The correction loop (runs alongside, not inside)

Any time anyone corrects you — PR comment, demo remark, Teams message — it goes into
`/ledger` the same day, generalised into a rule. `/ledger check` then runs before every
PR and demo. A rule that fires twice stops being a note and becomes a hard rule in
`.windsurf/rules/`. The point is narrow and worth stating plainly: seniors forgive
first-time mistakes and remember repeated ones.

## The three-environment split

You have three AI environments with different constraints. Use each for what it's good at:

| | **Copilot GPT (work Windows host)** | **Windsurf / Devin Desktop (work Linux VM)** | **Claude Code at home** |
|---|---|---|---|
| Budget | unlimited | ~1000 credits/month — precious | effectively unlimited |
| Model strength | strong | older/weaker models | strong reasoning |
| Has your code | ❌ chat-only — feed it **context packs** (see copilot-bridge) | ✅ full repo context | ❌ never paste work code |
| Use for | planning, design options, explaining pasted code, diff review, distilling reports, **drafting the Windsurf prompts** | executing prepared prompts: generation and multi-file edits only; wiki/Bitbucket MCP lookups | domain concepts abstractly, skill/workflow maintenance, career strategy |

The pipeline: Windsurf/terminal gathers (free) → `context-pack.sh` distills (free) →
Copilot plans and drafts the prompt (free) → Windsurf executes it (the ONLY paid step)
→ Copilot reviews the diff (free) → `/verify` gates the commit. Credits buy typing;
everything else is free.

> **Since the Devin Local switch there is a second cheap lane inside the work VM:
> subagents.** Gathering work — file discovery, call-chain tracing, precedent sweeps —
> runs on the cheap default subagent model in its own context window, so it neither
> spends the good model nor pollutes the main conversation. Ask for it in words
> ("research how X works in an explore subagent"), or let a skill declare
> `subagent: true` the way `precedent-check` does. Devin Local is also ~30% more
> token-efficient than Cascade for the same work.

> ⚠ One-time check: confirm your Copilot is the enterprise/work-account variant
> (commercial data protection) before pasting company code into it.

## Weekly ritual (Friday, 20 minutes)

1. Run `/standup-reporter weekly` → wins summary.
2. Skim this week's impl-logs → copy one "lesson learned" into a knowledge note.
3. Look at your open briefs → anything stuck > 3 days? That's Monday's first question, with
   options attached ("I see two ways: A or B — I lean A because X. Which do you prefer?").

## Why this makes you look strong (not just be strong)

- **Questions with options** signal ownership. "How do I do this?" signals dependence.
  The brief manufactures the first kind.
- **A filled test-plan in every PR description** is what seniors notice.
- **The logs are your performance review file.** Three months from now you can show exactly
  what you shipped, what you learned, and how your fix-count-per-task dropped.
