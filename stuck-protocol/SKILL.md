---
name: stuck-protocol
description: 'Escalation ladder for being stuck or lost: timeboxed self-attempts with a documented trail, then a well-formed question with evidence and a best guess. Also covers the question parking-lot and recurring question-slot habits. Use when feeling stuck, lost, or hesitant to ask colleagues for help.'
---

# Stuck Protocol

For the developer who loses hours because asking feels like disturbing people.
Two research-backed facts to internalize first:

1. Managers report the classic junior failure mode is NOT asking too much — it's
   silently burning a day in rabbit holes. A senior's job description includes
   answering you; a junior who asks *well-formed* questions reads as strong.
2. The fear is solved by process, not courage: a timebox decides *when* to ask,
   and the evidence trail decides *how*. Nothing is left to your anxiety.

## The ladder (run it every time you're stuck)

**Rung 0 — Name the next subtask (2 min).** "Lost" usually means the task is too big.
Write the next 30-minute-sized piece. Can't name one? You're not stuck on code, you're
stuck on understanding → jump to Rung 3 with that as the question.

**Rung 1 — Timeboxed self-attempt (30 min, timer on).** Proportional rule: for a
multi-day task allow up to 2 hours total; for a same-day task, 30 minutes. During the
box, keep a **stuck log** (scratch file, telegraphic):
- what I'm trying to make happen
- attempt → result (exact error/wrong behavior)
- what I ruled out

**Rung 2 — Free resources sweep (15 min).** Grep for a precedent in the codebase, wiki
search, docs, knowledge notes. At home: ask Claude abstractly. Never spend work AI
credits here (see token-sniper), and never accept an AI explanation of the codebase
without one verification hop (read the actual method it describes).

**Rung 3 — Ask, using the trail.** The stuck log IS the question. Format:

> "I'm trying to [goal]. I tried [A] → [result], and [B] → [result].
> My best guess is [C] because [reasoning]. Am I on the right track?"

The best-guess line is mandatory — even a wrong guess shows thinking, invites teaching,
and converts "help me" into a 2-minute confirm for the senior. Timer expired = asking
is now the *disciplined* move; NOT asking is the unprofessional one.

## Standing structures (set up once, remove the guilt forever)

- **Question slot:** ask the boss/senior for a recurring 15-min slot 2-3×/week for
  batched questions. Script: "Instead of interrupting you randomly, can I collect my
  questions for a 15-minute slot on Tue/Thu? I'll come with attempts documented."
  Seniors nearly always say yes — it costs them less than interrupts and reads as maturity.
- **Question parking lot:** one running note. Every unfamiliar term from
  standups/reviews/code goes in it — do NOT rabbit-hole mid-task. 20 min/day, look up
  the top items (or feed one to /domain-tutor). Meetings become progressively less alien.
- **Calibration prefix** (for "they forget I'm new"): open questions with
  "possibly a basics gap — I'm 3 months in:". It resets their expectations *for* them,
  and its disappearance over time is visible growth.
- **Safe person:** identify the one teammate who answers without judgment; route
  Rung-3 basics to them, boss-worthy design questions to the boss.

## Rules

- Never ask before Rung 1 (looks helpless), never sit stuck past 2× the timebox
  (looks worse — days of silence is the #1 way juniors get labeled weak).
- Every Rung-3 answer you receive goes into the parking lot or a knowledge note —
  paying the asking-cost twice for the same question is the only real "dumb question".
- Track asks in the impl-log; the trend line ("asked 5×/week in July, 2×/week in
  September, questions got deeper") is promotion-review material.
