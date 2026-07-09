---
name: flow-tracer
description: 'Trace ONE runtime flow through the code into a verified call-chain note: entry point → real Class.method steps → data shapes → async/repo boundaries, each step marked verified or inferred. Use for any "what actually happens when X" question, when a blast radius touches a flow you cannot narrate, or before touching code whose path you have never followed.'
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion, mcp__serena__find_symbol, mcp__serena__find_referencing_symbols, mcp__octocode__localSearchCode, mcp__octocode__lspGotoDefinition, mcp__octocode__lspCallHierarchy
---

# Flow Tracer

The single biggest time-to-first-commit leak is tracing: knowing WHAT to change but
spending days finding WHERE and how the pieces connect. This skill turns one tracing
session into a permanent, verified **trace note** — so the next task in that area
starts from the trace, not from zero.

Two habits ship with it and are enforced by its gates:
1. **The 10-minute rule** — a step that survives 10 minutes of static reading
   unexplained (DI magic, `@Async`, Spring proxies) gets a breakpoint at the entry
   point and ONE real request stepped through. Runtime is ground truth.
2. **Never trace twice** — no tracing session ends without its note. Re-deriving a
   flow you already traced is the leak this skill exists to plug.

## When this triggers

- "What actually happens when X?" (a chat message arrives, a topology event fires,
  a button is clicked) — any flow the user can't narrate end-to-end.
- A `feature-brief` blast radius (Step 3) touches a flow with no trace note.
- Mid-task: the user is lost inside a call chain ("who even calls this?").
- The user invokes `/flow-tracer` or `/trace`.

## When this does not trigger

- What a concept *means* (what IS a topology link) → `domain-tutor` — tracer follows
  code paths; tutor teaches meaning.
- Where things *live* structurally across repos → `code-cartographer` — the map is
  the atlas; a trace is one route drawn on it.
- Debugging a specific failure with a stack trace in hand → follow the stack trace;
  a trace note may fall out of it as a bonus.

## Required inputs

- **ONE entry point**, concrete: an endpoint (`POST /api/chat`), an event
  (`LinkDownEvent`), a UI action, a scheduled job. "Trace the chatbot" is not an
  entry point — ask via interactive multi-choice to pin one.
- **Prior art check:** `.agent/knowledge/traces/INDEX.md` FIRST. A hit means
  re-verify (minutes), not re-trace. A trace older than ~60 days or touching
  since-refactored code gets its `⚠` re-checked before being trusted.
- The stopping edge: where does this trace end (response out / report written /
  repo boundary)? Default: the first async or repo boundary past the task's code.

## Workflow

### Step 1 — Check the index
Read `traces/INDEX.md`. Existing trace → jump to Step 4 (re-verify its `⚠` and
staleness), done. Related trace (shares a segment) → extend it, don't fork it.

### Step 2 — Draft the chain (free tools only)
Build the hypothesis chain from the entry point: grep for the route/event handler,
then follow with call hierarchy / `find_referencing_symbols` / reading. Record each
step as `Class.method` + what happens to the data + boundary flags (async, repo-hop,
transaction). **Every step gets a marker: `verified: read` or `⚠ inferred`.**
Tracing is retrieval — it never spends a paid generation (in Windsurf: terminal +
lookups, not Cascade generations; or draft via a Copilot context pack).

### Step 3 — Verify the ⚠ steps (the user's part)
Walk each `⚠` in the code. **10-minute rule:** a step that resists static reading —
proxies, `@Async` executors, event dispatch, tool selection — gets a breakpoint at
the entry point and one real request stepped through; upgrade it to
`verified: debugger`. Surprises found while stepping (thread changes, swallowed
exceptions, config redirects) go in the note's Gotchas section — they're the
highest-value lines in it.

### Step 4 — Land the note
Write/update `.agent/knowledge/traces/<flow-name>.md` from
`assets/trace-template.md` (name-keyed, kebab-case — flows are knowledge, not task
logs). Update the INDEX line. Cross-feed: any repo-hop discovered is an **anchored
SYSTEM-MAP edge** — add it via `code-cartographer` conventions (the anchor is the
step that proved it). If a brief is active, link the trace from its blast radius.

## Decision gates

- ONE flow per session, time-boxed 30-45 min. A ballooning trace means the flow is
  too big — split at an async/repo boundary and trace the half blocking today's task.
- No session ends without the note + INDEX line (never-trace-twice is a gate, not
  advice). 2 minutes, telegraphic.
- The AI's draft is a hypothesis, not truth — a trace with unverified `⚠` steps on
  the task's critical path is not done.
- Traces are internal architecture: work `.agent/` only, never a personal repo,
  never pasted into personal AI accounts.

## Output format

Persistent artifact: the trace note + its INDEX line. In chat: the chain in ≤15
lines, the `⚠` list still open, and any SYSTEM-MAP edges harvested.

## Gotchas

- The `⚠` steps are exactly where Spring's magic makes plausible guesses wrong —
  self-invocation proxy traps, listener registration order, async executors. That's
  why the 10-minute rule exists; the debugger settles in minutes what reading debates
  for an hour.
- Data shapes matter as much as method names — half of tracing pain is "what exactly
  is inside the DTO at this point".
- Don't trace to exhaustive depth; trace to the stopping edge that unblocks the task.
- A stale trace is worse than none because it's trusted — re-verify before relying.

## Evaluation checklist

- [ ] INDEX checked before tracing; existing/related trace reused or extended?
- [ ] One concrete entry point pinned (via interactive options if vague)?
- [ ] Draft built with free tools; every step marked `verified` / `⚠ inferred`?
- [ ] `⚠` steps on the critical path verified — debugger used past the 10-min mark?
- [ ] Note saved (name-keyed) + INDEX updated + repo-hops fed to SYSTEM-MAP?

## Assets

- `assets/trace-template.md` — the trace note structure (header, chain table,
  boundary notes, gotchas, open `⚠`).
