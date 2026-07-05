# The Master Loop

Every task from your boss runs through the same loop. The loop exists because of one hard-won
lesson (yours): **starting to code before understanding the problem is what creates the endless
fix cycle and makes you look worse than you are.** Twenty minutes of structured understanding
up front replaces two days of flailing.

```
        TASK ARRIVES (from Danny / Jira / chat)
              │
              ▼
 ┌─ 1. UNDERSTAND ──────────────────────────────┐
 │  /feature-brief  → one-page brief             │
 │  Domain gap found? → /domain-tutor first      │
 │  Output: 2-4 smart questions for Danny        │◄─── This is where you WIN.
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
 │  /explain-before-merge                        │
 │  ⛔ HARD GATE: if you can't explain a line,   │
 │     you don't commit it.                      │
 └──────────────┬───────────────────────────────┘
                ▼
 ┌─ 5. LOG ─────────────────────────────────────┐
 │  /impl-log → what was generated, what you     │
 │  verified, what you learned.                  │
 └──────────────┬───────────────────────────────┘
                ▼
 ┌─ 6. REPORT ──────────────────────────────────┐
 │  /standup-reporter (daily + Friday wins)      │
 └──────────────────────────────────────────────┘
```

## The two-environment split

You have two AI environments with opposite constraints. Use each for what it's good at:

| | **Claude Code at home** | **Windsurf at work** |
|---|---|---|
| Budget | effectively unlimited | ~1000 credits/month — precious |
| Model strength | strong reasoning | older/weaker models |
| Has your code | ❌ never paste it | ✅ full repo context |
| Use for | learning domain concepts abstractly, planning approaches, drafting briefs/prompts, Spring AI questions, career strategy | code generation **with prepared prompts**, repo-specific edits, wiki/Bitbucket MCP lookups |

The workflow is designed so the *expensive thinking* happens at home for free, and work credits
are spent only on the final, well-specified generation step.

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
