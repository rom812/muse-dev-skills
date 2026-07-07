---
name: vaadin-mentor
description: 'Reference knowledge and patterns for Vaadin Flow UIs, especially AI-chatbot integration: background-thread UI updates (UI.access/@Push), session/UI scopes, JS integration for audio/STT/TTS, streaming responses into components. Use when designing, implementing, or debugging Vaadin UI code.'
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, mcp__tavily__tavily_search, mcp__exa__exa_search
---

# Vaadin Mentor

Vaadin Flow is a server-side UI framework with unusual threading and state rules, and
it's niche enough that AI models hallucinate around it — especially the combination
that defines this project: **async AI responses updating a live UI**. This skill
carries a curated reference (`references/vaadin-patterns.md`) so generations follow
Vaadin's actual rules.

## When this triggers

- Implementing/debugging anything in the chatbot's UI: chat panel, avatar, audio
  (STT/TTS), progress indicators, streaming responses.
- Symptoms like: UI doesn't update until refresh/click, `IllegalStateException` about
  UI/session access, users seeing each other's conversations, frozen UI during AI calls.
- The user invokes `/vaadin-mentor`.

## When this does not trigger

- Backend Spring AI questions (tools, memory, structured output) → `spring-ai-mentor`.
- Product-domain concepts → `domain-tutor`.
- Non-UI Spring questions (transactions, beans in services) → general knowledge or
  `spring-ai-mentor` §7 for the overlap cases.

## Required inputs

- The Vaadin version (`pom.xml`) — the reference assumes 24+ (Jakarta, Spring Boot 3);
  at home without the code, ask and mark advice `⚠ verify against your version`.
- The component/flow in question, and for bugs: the exact symptom.

## Workflow

1. **Check the version**, then **load `references/vaadin-patterns.md`**.
2. For "UI not updating" or cross-user-data bugs, start from the threading (§2) and
   scope (§4) sections — that's the cause in the overwhelming majority of cases.
3. **Enforce the two iron invariants in any review of chatbot UI code:** background
   threads touch components only inside `ui.access(...)` with push enabled; per-
   conversation state lives in UI/session-scoped beans, never singleton fields.
4. For STT/TTS/avatar work, respect the browser boundary (§5): mic capture and audio
   playback are client-side JS; the server only orchestrates.
5. **Optional freshness check:** for APIs that may have moved (Vaadin releases twice a
   year), verify against current vaadin.com docs via a web-search tool if available
   (**Exa MCP in Windsurf**, Tavily/WebSearch at home). Skip for the settled threading/
   scope rules — those are stable.

## Decision gates

- No answer before the version check.
- If the codebase's existing UI precedent diverges from the reference, follow the
  precedent and note the divergence — don't refactor unprompted.
- Project-specific UI discoveries (how *this* app wires the chat panel, push config)
  go to `domain-tutor` knowledge notes at work — this reference stays generic Vaadin.

## Output format

In chat: the pattern or diagnosis citing the reference section (e.g. "§2 background
thread → UI update"), code adapted to the project's conventions, `⚠ verify against
your version` where applicable. No persistent artifact.

## Gotchas

- "Answer appears only after clicking somewhere" = missing `@Push` — check it before
  debugging anything else.
- `UI.getCurrent()` is null on background threads — capture it before going async.
- One `ui.access` per streamed token can flood the push channel — batch tokens.
- Session-scoped beans must hold serializable state — inject services, don't store them.

## Evaluation checklist

- [ ] Version anchored before answering (or `⚠ verify` flagged)?
- [ ] Threading and scope invariants checked first for update/cross-user bugs?
- [ ] Browser boundary respected in any audio/avatar design?
- [ ] Answer cites the relevant reference section?

## References

- `references/vaadin-patterns.md` — the curated reference (threading model, ui.access/
  @Push, streaming, scopes, JS/audio boundary, long-op UX, pitfall table, testing).
