---
trigger: always_on
---

# AI Discipline Rules

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
- After changes, update the matching log at `.agent/logs/NNN-<task>.md` (run /log).
