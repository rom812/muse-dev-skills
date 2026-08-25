---
name: brainstorm
description: 'Explore a vague idea or open problem into a validated approach through one-at-a-time multi-choice questions, 2-3 alternatives with trade-offs, and an incremental design check. Use BEFORE a task is concrete — when the user has an idea, an open-ended ask from the boss, or several possible directions and no committed approach.'
---

# Brainstorm

Adapted from the most-installed brainstorming skill in the ecosystem
(obra/superpowers, 260K+ installs) and fitted to this workflow: one question at a
time, alternatives before commitment, incremental validation — with one-click
answers and an output that feeds `feature-brief`.

## When this triggers

- The user has an idea or an open-ended ask with no committed approach: "my boss wants
  the bot to be more proactive — ideas?", "how could we improve the avatar?".
- A feature-brief stalled because the *approach itself* is undecided (not the requirements).
- The user invokes `/brainstorm`.

## When this does not trigger

- The task is already concrete (what to build is known) → `feature-brief`.
- The approach is chosen and needs step-by-step decomposition → `task-planner`.
- The gap is domain knowledge, not ideas → `domain-tutor`.

## Required inputs

- The idea or open problem, in the user's words.
- Context: whose idea is it (user's own / the boss's), and what would "success" look like.
- How much freedom exists (proposal for the boss vs decision the user owns).

## Interactive questions rule

**One question per message**, multi-choice preferred, via the interactive UI
(`AskUserQuestion` in Claude Code, suggested responses in Cascade) — a topic needing
depth becomes several sequential one-click questions, never one wall of text.

## Workflow

### Step 1 — Ground in reality
Check current project context first (existing briefs, knowledge notes, the relevant
code area if available). Ideas built on wrong assumptions waste everyone's time.

### Step 2 — Refine the idea (one question at a time)
Ask single questions to pin down: purpose · who benefits · constraints · success
criteria. Stop as soon as the shape is clear — this is refinement, not an interrogation.

### Step 3 — Optional research sweep
If a web-search tool is available (Exa MCP at work, Tavily/WebSearch at home), 1-2
searches: how do similar products/chatbots solve this? Feed findings into Step 4 as
candidate approaches, cited.

### Step 4 — Explore 2-3 approaches
Present alternatives with trade-offs, **leading with a recommendation and why**.
Apply YAGNI ruthlessly — strike features nobody asked for. Offer the choice as
multi-choice options.

### Step 5 — Validate the design incrementally
Present the chosen approach in small sections (~200 words each) — flow, components,
error handling, effort estimate — checking "does this look right?" after each via
one-click options. Go back when something doesn't fit.

### Step 6 — Land the output where it's useful
- Idea for the boss → a short options-plus-leaning proposal message, ready to send
  (the standup-reporter blocker phrasing style: "I see A or B, I lean A because…").
- Idea to build → seed a `feature-brief` (the validated approach pre-fills §2 and §6)
  and save the exploration to `.agent/briefs/NNN-<topic>-brainstorm.md`.

## Decision gates

- No implementation, no code, no task-planner until an approach is validated AND (if
  it's the boss's call) approved by the boss.
- If Step 2 reveals the real gap is domain knowledge → stop, route to `domain-tutor`.
- If the user already knows exactly what to build → skip to `feature-brief`; say so.

## Output format

In chat: the alternatives table (approach / trade-offs / recommendation) and the
validated design sections. Persistent artifact: the proposal message or the seeded
brief/brainstorm file — always something that outlives the conversation.

## Gotchas

- One question per message — a batch of five questions kills the exploration.
- Always 2-3 alternatives before settling; the first idea is rarely the best and a
  junior proposing *options* reads as senior thinking.
- YAGNI: brainstorms balloon; strike anything not serving the stated success criteria.
- Don't let a brainstorm silently become implementation — the gate exists because
  "exploring" is how unplanned code sneaks in.

## Evaluation checklist

- [ ] Questions asked one at a time, multi-choice, via the interactive UI?
- [ ] 2-3 alternatives presented with trade-offs and a stated recommendation?
- [ ] Design validated in increments, not one monolith?
- [ ] Output landed as a proposal message or a seeded brief (not just chat)?
- [ ] YAGNI applied — cut list visible?
