---
name: vaadin-mentor
description: 'Reference knowledge and patterns for Vaadin Flow UIs, especially AI-chatbot integration: background-thread UI updates (UI.access/@Push), session/UI scopes, JS integration for audio/STT/TTS, streaming responses into components. Use when designing, implementing, or debugging Vaadin UI code.'
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

## Protocol

1. **Check the Vaadin version** (`pom.xml`) — Vaadin 24+ (Jakarta, Spring Boot 3) is
   assumed by the reference; older versions differ. At home without code, ask and mark
   advice `⚠ verify against your version`.
2. **Load `references/vaadin-patterns.md`.** For any bug involving "UI not updating"
   or cross-user data, start from the threading/scope sections — that's the cause in
   the overwhelming majority of cases.
3. **The iron rule for this project:** any code path where the AI (or any background
   thread) touches a component must run inside `ui.access(...)`, with push enabled.
   Any per-conversation state must live in a UI/session-scoped bean, never a singleton
   field. Check these two invariants FIRST in every review of chatbot UI code.
4. **For STT/TTS/avatar work**, remember the browser boundary: microphone capture and
   audio playback happen client-side (JS); the server only orchestrates. Route designs
   through the JS-integration section of the reference.

## Maintaining the reference

Project-specific discoveries (how *this* app wires the chat panel, its push config,
its custom components) belong in `/domain-tutor` knowledge notes at work — this file
stays generic Vaadin.
