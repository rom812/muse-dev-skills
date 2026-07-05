---
name: standup-reporter
description: 'Turn impl-logs and briefs into crisp progress updates: daily standup lines, Friday wins summaries, and blockers phrased as options with a recommendation. Use for daily updates, weekly summaries, or before a 1:1 with the boss.'
---

# Standup Reporter

Half of "he can't get things done" is actually "nobody hears about what he does."
This skill converts the paper trail (`.agent/logs/`, `.agent/briefs/`) into updates that
make delivered work — and competent process — visible.

## When this triggers

- Daily: user asks for a standup update.
- Friday: user asks for a weekly summary.
- Before a 1:1 or when the boss asks "where are we on X".
- User invokes `/standup-reporter` (optionally with `weekly`).

## Inputs

Read `.agent/logs/*` and `.agent/briefs/*` modified in the relevant window. If they're
not available in this environment, ask the user for a 3-line dump of what happened and
build from that.

## Daily format

```
Yesterday: [shipped/progressed — concrete, past tense: "finished X, verified with Y"]
Today:     [1-2 items, tied to the task, not "continue working"]
Blockers:  [see phrasing rules — or "none"]
```

## Blocker phrasing rules (the career-critical part)

- ❌ "I'm stuck on X." / "I don't understand X."
- ✅ "For X I see two options: (A) …, (B) …. I lean A because …. Danny, do you have
  context that changes this?"
- ✅ "X is waiting on [answer/access/review since <date>] — meanwhile I've moved on Y."
- A blocker with an owner, an age, and a proposed way forward reads as *driving*;
  a bare blocker reads as *drowning*. Never report a blocker without one of the two.

## Weekly format (Friday, for yourself + easy 1:1 ammo)

```
## Week of YYYY-MM-DD
Shipped:      [task → one line each, with proof: "merged, tested via …"]
In progress:  [task → % and what's left]
Learned:      [1-2 domain/tech items — pulled from impl-log "What I learned"]
Fix-cycle count: [N this week — track the downward trend]
Next week:    [top 2 priorities as I understand them — flags misalignment early]
```

The "Next week" section is secretly the most valuable line: if the boss corrects it,
you just avoided a week of work on the wrong thing.

## Tone rules

- Concrete beats busy: "implemented the link-deletion report tool, verified against a
  test topology" > "worked on the reporting feature".
- Past tense + evidence for done work; no hedging words ("kind of", "I think it works").
- Never inflate: the logs make honest claims provable, which is the whole point.
- Keep the daily under 60 words. Nobody reads long standups.
