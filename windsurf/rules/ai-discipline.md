---
trigger: always_on
---

# AI Discipline Rules

- Workflows never run automatically in Cascade — so when my request matches one,
  point me to it instead of improvising the process ad hoc: new task → /brief ·
  vague idea → /brainstorm · multi-file plan → /plan · about to commit AI code →
  /verify · just generated code / something broke / shipped → /log · "what happens
  when X?" → /trace · "where does X live?" → /map · concept I can't explain →
  /tutor · stuck past a timebox → /stuck · status update → /standup.
- Whenever you need input from me, batch ALL questions into ONE message and present
  them as suggested responses / interactive multi-choice options (always include an
  "other" option). Never end a turn with an open free-text question when options are
  possible — every extra turn costs me credits.
- The Exa MCP is available: for non-trivial patterns, unfamiliar errors, or possibly-
  outdated APIs, a quick Exa search for best practices / the exact error string is
  encouraged BEFORE generating code — search is far cheaper than a wrong implementation.
- Before implementing any non-trivial task, a feature brief must exist at
  `.agent/briefs/NNN-<task>.md` (run /brief). If none exists, create one first — do not
  jump to code.
- Always look for an existing precedent in this codebase and imitate its pattern
  (naming, error handling, layering) instead of inventing a new one.
- When generating code: explain any non-obvious line in one sentence, and end every
  generation with a short "what to test to prove this works" list.
- Never leave placeholders, TODOs, or hardcoded values that belong in application.yml.
- For Spring AI: tool selection quality depends on @Tool/@ToolParam descriptions —
  write them as carefully as code. Use .entity() for structured output, never hand-parse
  LLM JSON. No shared mutable state in singleton bean fields. Timeouts on all LLM calls.
- Before generating Spring AI or Vaadin code, read the matching pattern file if present
  and imitate its patterns: `.agent/reference/spring-ai-patterns.md`,
  `.agent/reference/vaadin-patterns.md`. They override your training-data defaults
  (e.g. use @Tool, never the deprecated FunctionCallback API).
- For Vaadin: never touch components from background threads except inside
  `ui.access(...)` (capture `UI.getCurrent()` before going async, `@Push` required);
  per-conversation/user state lives in `@UIScope`/session-scoped beans, never in
  singleton fields; LLM calls never run on the UI/request thread.
- After changes, update the matching impl log at `.agent/design-logs/NNN-<task>.md`
  (run /log) — impl logs share the design-logs folder, numbering, and INDEX.md.
- Flow questions have a 10-minute static-reading budget: if tracing "what happens
  when X" by reading stalls past it, stop — breakpoint at the entry point, ONE real
  request, step through (run /trace). Runtime is ground truth.
- No tracing session ends without its note: `.agent/knowledge/traces/<flow>.md` +
  INDEX line (2 minutes, telegraphic). Re-deriving a flow already traced is the leak.
