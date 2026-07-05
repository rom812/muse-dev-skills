---
name: spring-ai-mentor
description: 'Reference knowledge and patterns for Spring AI development (ChatClient, tool calling, advisors, chat memory, structured output, RAG) plus common pitfalls in AI chatbot backends. Use when designing, implementing, or debugging Spring AI features.'
---

# Spring AI Mentor

Spring AI is newer than most models' training data, and weaker/older models at work
hallucinate its APIs. This skill compensates: it carries a curated pattern reference
(`references/spring-ai-patterns.md`) so any model — strong or weak — works from correct,
project-verified patterns instead of guesses.

## When this triggers

- Designing or implementing anything touching Spring AI: chat flows, tools/function
  calling, advisors, memory, structured output, RAG, streaming.
- Debugging "the model doesn't call my tool", "the response isn't parsed", memory issues.
- The user invokes `/spring-ai-mentor`.

## Protocol

1. **Anchor to the project's version first.** Check `pom.xml` / `build.gradle` for the
   `spring-ai` version. APIs changed heavily before 1.0 — a pattern that's right for 1.0+
   may not compile on a milestone version. When at home without the code, ask the user
   which version and mark advice `⚠ verify against your version`.
2. **Load `references/spring-ai-patterns.md`** and answer from it, adapting to the
   project's conventions (found via the nearest existing precedent in the codebase).
3. **Prefer the framework over hand-rolling.** If the user is about to hand-roll JSON
   parsing of LLM output, tool dispatch, or conversation history — the framework has
   `entity()`, `@Tool`, and `ChatMemory` for that. Check the reference first.
4. **For debugging**, start from the pitfalls section of the reference — tool-calling
   failures in particular are almost always description/schema problems, not code problems.

## Maintaining the reference

When the user learns something project-specific (how *their* chatbot registers tools, how
jobs/triggers dispatch to the AI), that goes into a `/domain-tutor` knowledge note at work —
NOT into this file. This file stays generic-Spring-AI so it can live in a personal repo.

When Spring AI releases change an API the reference uses, update the reference and note
the version it was verified against.
