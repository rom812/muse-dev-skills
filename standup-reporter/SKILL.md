---
name: standup-reporter
description: 'Turn impl-logs and briefs into crisp progress updates: daily standup lines, Friday wins summaries, and blockers phrased as options with a recommendation. Use for daily updates, weekly summaries, or before a 1:1 with the boss.'
allowed-tools: Read, Grep, Glob, AskUserQuestion
---

# Standup Reporter

Half of "he can't get things done" is actually "nobody hears about what he does."
This skill converts the paper trail (`.agent/logs/`, `.agent/briefs/`) into updates
that make delivered work — and competent process — visible.

## When this triggers

- Daily: the user asks for a standup update.
- Friday: the user asks for a weekly summary.
- Before a 1:1 or when the boss asks "where are we on X".
- The user invokes `/standup-reporter` (optionally with `weekly`).

## When this does not trigger

- Recording what happened → `impl-log` (this skill only reads).
- Composing clarifying questions for a new task → `feature-brief` Step 5.
- Escalating a blocker in real time → `stuck-protocol` (this skill reports blockers;
  that one resolves them).

## Required inputs

- The window: daily (since yesterday) or weekly (last 7 days) — if ambiguous, ask via
  interactive multi-choice (`AskUserQuestion` / Cascade suggested responses), one message.
- `.agent/logs/*` and `.agent/briefs/*` modified in the window; if unavailable in this
  environment, ask for a 3-line dump of what happened and build from that.

## Workflow

### Daily (under 60 words)
**Yesterday:** shipped/progressed — concrete, past tense, with proof ("finished X,
verified with Y") · **Today:** 1-2 items tied to tasks (never "continue working") ·
**Blockers:** per the phrasing rules, or "none".

### Weekly (Friday; 1:1 ammo)
**Shipped** (one line each, with proof) · **In progress** (% + what's left) ·
**Learned** (1-2 items pulled from the logs' "What I learned") · **Fix-cycle count**
(track the downward trend) · **Next week** (top 2 priorities *as I understand them* —
the misalignment radar; a correction here saves a week of wrong work).

### Blocker phrasing rules (the career-critical part)
- Never a bare "stuck on X" / "I don't understand X".
- Either: "For X I see options A or B, I lean A because… — do you have context that
  changes this?" · Or: "X is waiting on [thing] since [date] — meanwhile progressing on Y."
- Every blocker carries an owner, an age, and a proposed way forward: with those it
  reads as *driving*; bare, it reads as *drowning*.

## Decision gates

- Don't invent or inflate: every "shipped" claim must be traceable to a log entry —
  the logs make honest claims provable, which is the whole point.
- Don't soften the blocker rules back into vague status ("still fighting with X").
- If the logs are empty for the window, say so and produce the update from the user's
  dump — flagged as unverified.

## Output format

The formatted update, ready to paste (chat/standup/1:1 doc). Daily: 3 lines, <60 words.
Weekly: the 5 sections above. Nothing else — no meta-commentary around it.

## Gotchas

- Relevance beats completeness: lead with what the boss currently cares about.
- Past tense + evidence for done work; no hedging ("kind of works").
- Don't skip bad weeks — a controlled, honest, options-forward update protects most
  exactly then.

## Evaluation checklist

- [ ] Window confirmed (or asked via interactive UI, one message)?
- [ ] Daily under 60 words, concrete, past tense with proof?
- [ ] Every blocker has owner + age + proposed way forward (or options + leaning)?
- [ ] Weekly includes "Next week" priorities to invite early correction?
- [ ] Every claim traceable to a log/brief entry?
