---
trigger: model_decision
description: Vaadin Flow hard constraints. Apply when writing, reviewing, or debugging Vaadin UI code — views, components, background updates, push, session/UI scope, or streaming LLM output into the UI.
---

# Vaadin Flow Constraints

- Never touch components from a background thread except inside `ui.access(...)`.
  Capture `UI.getCurrent()` before going async. `@Push` is required.
- Per-conversation and per-user state lives in `@UIScope` / session-scoped beans,
  never in singleton fields.
- LLM calls never run on the UI or request thread.
- Read `.agent/reference/vaadin-patterns.md` before generating and imitate its patterns —
  it overrides your training-data defaults.

For the full pattern reference (streaming, STT/TTS JS integration), use the
`vaadin-mentor` skill.
