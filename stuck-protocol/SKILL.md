---
name: stuck-protocol
description: 'Escalation ladder for being stuck or lost: timeboxed self-attempts with a documented trail, then a well-formed question with evidence and a best guess. Also covers the question parking-lot and recurring question-slot habits. Use when feeling stuck, lost, or hesitant to ask colleagues for help.'
allowed-tools: Read, Write, Grep, Glob, Bash, AskUserQuestion, WebSearch, WebFetch, mcp__tavily__tavily_search, mcp__exa__exa_search
---

# Stuck Protocol

For the developer who loses hours because asking feels like disturbing people. Two
facts to internalize: (1) managers report the classic junior failure mode is NOT
asking too much — it's silently burning a day in rabbit holes; (2) the fear is solved
by process, not courage: a timebox decides *when* to ask, the evidence trail decides
*how*.

## When this triggers

- The user notices the lost feeling: re-reading the same code, aimless clicking, the
  urge to procrastinate — the feeling is the trigger, not "really" stuck.
- A timebox on a task expired without progress.
- The user invokes `/stuck-protocol` or `/stuck`.

## When this does not trigger

- Not understanding the *task* → `feature-brief` (requirements gap).
- Not understanding a *domain concept* → `domain-tutor`.
- Stuck tracing a runtime flow by reading (DI magic, proxies, async hops) →
  `flow-tracer` — its debugger rule replaces static reading past the 10-minute budget.
- A failed AI generation → `token-sniper` Step 4 (evidence, then one surgical retry).

## Required inputs

- What the user is trying to make happen, in one sentence (if they can't say it, the
  gap is understanding — route accordingly).
- What they've tried so far, if anything.
- Deadline context (sets the timebox size).

## Interactive questions rule

All questions to the user (rung choices, routing, "can you name the next subtask?")
go through the interactive question UI — `AskUserQuestion` in Claude Code,
suggested-responses multi-choice in Cascade — batched into one message, so answering
costs one click, not one turn.

## Workflow

**Rung 0 — Name the next subtask (2 min).** "Lost" usually means the task is too big.
Name the next 30-minute-sized piece. Can't name one? The block is understanding →
Rung 3 with that as the question.

**Rung 1 — Timeboxed self-attempt (30 min, real timer).** Proportional rule: same-day
task → 30 min; multi-day task → up to 2h total. Keep a **stuck log** (scratch file,
telegraphic): goal · attempt → result (exact error) · ruled out.

**Rung 2 — Free resources sweep (15 min).** Grep for a precedent · wiki search ·
knowledge notes · docs · **web-search the exact error message** (Exa MCP in Windsurf,
Tavily/WebSearch at home — quoted error strings find the blog post that solves it).
Never spend generation credits here, and never accept an AI explanation of the
codebase without one verification hop (open the actual method).

**Rung 3 — Ask, using the trail.** The stuck log IS the question:
"I'm trying to [goal]. I tried [A] → [result], [B] → [result]. My best guess is [C]
because [reasoning]. Am I on the right track?" The best-guess line is mandatory. Route
by weight: basics → the safe person · design/scope → the boss · batched small stuff →
the recurring question slot.

### Standing structures (set up once, remove the guilt forever)
- **Question slot:** recurring 15-min batched-questions slot 2-3×/week with the boss.
- **Question parking lot:** one running note; every unfamiliar term from meetings/code
  goes in — no mid-task rabbit holes; 20 min/day lookup (or feed one to `domain-tutor`).
- **Calibration prefix:** open with "possibly a basics gap — I'm N months in:" — resets
  their expectations for them; its disappearance over time is visible growth.
- **Safe person:** the one teammate who answers without judgment.

## Decision gates

- Never ask before Rung 1 (looks helpless); never sit stuck past 2× the timebox
  (days of silence is the #1 way juniors get labeled weak).
- Timer expired = asking is now the disciplined move, not the failure.
- Every answer received goes into the parking lot or a knowledge note — paying the
  asking-cost twice for the same question is the only real "dumb question".

## Output format

The composed, ready-to-send ask (goal · attempts → results · best guess · question),
plus the routing recommendation (safe person / slot / boss now). Asks get logged in
the impl-log; answers land in the parking lot or a knowledge note.

## Gotchas

- Without a real timer the 30-minute box silently becomes 3 hours — this is THE
  failure mode the protocol exists for.
- Rung 0 resolves half of all cases — don't skip it to "get to the real steps".
- Composing the ask from the stuck log means no composing under stress — copy, add
  the best guess, send.

## Evaluation checklist

- [ ] Rung 0 asked via interactive UI before anything else?
- [ ] A real timer set, sized to the deadline?
- [ ] Stuck log kept (goal / attempts → results / ruled out)?
- [ ] Rung 2 included a quoted-error web search where a search tool exists?
- [ ] The final ask contains a best guess and got a routing recommendation?
