---
name: spring-ai-mentor
description: 'Reference knowledge and patterns for Spring AI development (ChatClient, tool calling, advisors, chat memory, structured output, RAG) plus common pitfalls in AI chatbot backends. Use when designing, implementing, or debugging Spring AI features.'
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, mcp__tavily__tavily_search, mcp__exa__exa_search
---

# Spring AI Mentor

Spring AI is newer than most models' training data, and weaker/older models hallucinate
its APIs. This skill compensates: it carries a curated pattern reference
(`references/spring-ai-patterns.md`) so any model works from correct, version-anchored
patterns instead of guesses.

## When this triggers

- Designing or implementing anything touching Spring AI: chat flows, tools/function
  calling, advisors, memory, structured output, RAG, streaming.
- Debugging "the model doesn't call my tool", "the response isn't parsed", memory issues.
- The user invokes `/spring-ai-mentor`.

## When this does not trigger

- Vaadin/UI-side questions (push, scopes, JS integration) → `vaadin-mentor`.
- Product-domain concepts (topology, events, jobs as business objects) → `domain-tutor`.
- General "how do I prompt the work AI" questions → `token-sniper`.

## Required inputs

- The project's Spring AI version (`pom.xml`/`build.gradle`) — or, at home without the
  code, ask which version and mark advice `⚠ verify against your version`.
- The specific feature or symptom in question.

## Workflow

1. **Anchor to the version first.** APIs changed heavily before 1.0 — a pattern right
   for 1.0+ may not compile on a milestone version.
2. **Load `references/spring-ai-patterns.md`** and answer from it, adapting to the
   project's conventions (found via the nearest existing precedent in the codebase).
3. **Optional freshness check:** if the question touches an API that may have changed
   since the reference was written, and a web-search tool is available (**Exa MCP in
   Windsurf**, Tavily/WebSearch at home), verify against current official docs
   (docs.spring.io) before answering. Skip for settled patterns.
4. **Prefer the framework over hand-rolling.** Hand-parsed LLM JSON → `.entity()`;
   hand-rolled tool dispatch → `@Tool`; hand-kept history → `ChatMemory`.
5. **For debugging**, start from the reference's pitfall table — tool-calling failures
   are almost always description/schema problems, not code problems.

## Decision gates

- Never present a pre-1.0 pattern (`FunctionCallback` era) for a 1.0+ project or vice
  versa — version check comes before any answer.
- If the reference and the codebase's precedent disagree, the precedent wins; note the
  divergence instead of "correcting" it unprompted.
- Project-specific discoveries do NOT go into the reference — route them to a
  `domain-tutor` knowledge note at work; the reference stays generic.

## Output format

In chat: the pattern or diagnosis, citing the reference section (e.g. "§2 tool
calling"), with code adapted to the project's conventions, and `⚠ verify against your
version` where applicable. No persistent artifact — durable project knowledge goes to
`domain-tutor` notes.

## Gotchas

- Weak models confidently emit the deprecated `FunctionCallback` API — always
  cross-check generated Spring AI code against the reference.
- Tool descriptions are prompt engineering, not Java — review `@Tool`/`@ToolParam`
  text as carefully as code.
- Everything a tool returns is spent as context tokens — return compact DTOs, not
  entity dumps.
- When the reference is updated after a Spring AI release, note the version it was
  verified against.

## Evaluation checklist

- [ ] Version anchored before answering (or `⚠ verify` flagged)?
- [ ] Answer cites the relevant reference section rather than improvising?
- [ ] Codebase precedent respected where it diverges from the reference?
- [ ] Freshness check run (or consciously skipped) for potentially-changed APIs?

## References

- `references/spring-ai-patterns.md` — the curated pattern reference (ChatClient,
  tools, advisors, structured output, event-driven jobs, voice, pitfalls, testing).
