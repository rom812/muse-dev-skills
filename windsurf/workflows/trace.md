---
description: Trace one runtime flow into a verified call-chain note — entry point to stopping edge
---

# /trace — Flow Tracer

Trace notes live in `.agent/knowledge/traces/<flow-name>.md` (name-keyed kebab-case,
flows are knowledge) + `INDEX.md` (one line per trace). Time-box: 30-45 min, ONE flow.
For static structure / where-things-live → /map. For learning a concept → /tutor.
Cross-repo prerequisite (one-time, same as /map): all repos added to this workspace
via File → Add Folder to Workspace — otherwise repo-hops are invisible to retrieval.

1. Check `traces/INDEX.md` FIRST. Existing trace → re-verify its ⚠ and staleness
   (>60 days or refactored code = re-check), done in minutes. Related trace → extend it.
2. Pin ONE concrete entry point — endpoint / event / UI action / job — via
   suggested-responses options if I'm vague. Agree the stopping edge (default: first
   async or repo boundary past the task's code).
3. Draft the chain cheap. Credit discipline: my terminal recon is free (grep the
   route/event handler, listener registrations); Cascade then drafts the WHOLE chain
   in this session using its search/grep/read tools — retrieval work, so a cheap/free
   model is fine, and never iterate the draft turn-by-turn (each prompt costs a
   credit; one drafting pass, then verification is mine). Chain format: entry point →
   Class.method per step → data shape at each hop → boundary flags (async / repo-hop /
   transaction). Mark EVERY step `verified: read` or `⚠ inferred`. IDE call hierarchy
   (right-click → Show Call Hierarchy) is MY free tool for filling gaps — tell me
   where to point it instead of guessing.
4. Make me verify the ⚠ steps. **10-minute rule:** a step that resists 10 minutes of
   reading (DI magic, @Async, Spring proxies, tool selection) → breakpoint at the
   entry point, ONE real request, step through → upgrade to `verified: debugger`.
   Surprises found go in the note's Gotchas section.
5. Land it: write/update the trace note from the template structure (header with
   Entry point / Repos crossed / Last verified / Description + Keywords, chain table,
   boundary notes, gotchas, open ⚠) + update `INDEX.md`. **Never-trace-twice is a
   gate: no session ends without the note** (2 minutes, telegraphic).
6. Cross-feed: any repo-hop discovered = an anchored SYSTEM-MAP edge → add it per
   /map conventions. Active brief → link the trace from its blast radius.
7. Report: the chain in ≤15 lines, open ⚠ list, edges harvested.

Rules: traces are internal architecture — they stay in this work environment. A trace
with unverified ⚠ on the task's critical path is not done. Ballooning trace = flow too
big → split at a boundary, trace the half blocking today.
