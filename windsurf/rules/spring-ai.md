---
trigger: model_decision
description: Spring AI hard constraints. Apply when writing, reviewing, or debugging Spring AI code — ChatClient, tool calling, advisors, chat memory, structured output, RAG, or any LLM call in the backend.
---

# Spring AI Constraints

- Tool selection quality depends on `@Tool` / `@ToolParam` descriptions — write them as
  carefully as code. A vague description is a bug.
- Use `.entity()` for structured output. Never hand-parse LLM JSON.
- No shared mutable state in singleton bean fields.
- Timeouts on all LLM calls, without exception.
- LLM calls never run on the UI or request thread.
- Read `.agent/reference/spring-ai-patterns.md` before generating and imitate its
  patterns — it overrides your training-data defaults (e.g. use `@Tool`, never the
  deprecated `FunctionCallback` API).

For the full pattern reference and pitfall catalogue, use the `spring-ai-mentor` skill.
