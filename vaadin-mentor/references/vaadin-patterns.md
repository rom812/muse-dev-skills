# Vaadin Flow Patterns Reference (AI-chatbot flavored)

> Written for Vaadin 24+ (Flow, Jakarta, Spring Boot 3). Check `pom.xml`.
> Focused on what an AI-chatbot UI actually needs: threading, scopes, streaming, audio.

## 1. Mental model — why Vaadin bugs look weird

- The UI lives **on the server**. Java components mirror to the browser; state sits in
  the HTTP session. One `UI` instance ≈ one browser tab.
- Normally the server touches components only during a request from that tab. Anything
  else — an `@Async` method, a Spring AI call completing, a topology-event listener,
  a scheduled job — is a **background thread**, and Vaadin forbids it from touching
  the UI directly.

## 2. THE pattern: background thread → UI update

This is the heart of an AI chatbot in Vaadin (LLM calls take seconds; you must not
block, and you must push results):

```java
@Push                                   // on the AppShell class — enables WebSocket push
public class AppShell implements AppShellConfigurator {}
```

```java
UI ui = UI.getCurrent();                // capture ON the request thread, BEFORE going async
chatService.askAsync(question)          // returns CompletableFuture / runs off-thread
    .thenAccept(answer ->
        ui.access(() -> {               // re-locks the session; the ONLY legal way in
            messageList.add(new Message(answer));
            spinner.setVisible(false);
        }));
```

Rules that prevent 90% of chatbot-UI bugs:
- `UI.getCurrent()` is null on background threads — **capture it before** dispatching.
- Every component mutation from async code goes inside `ui.access(...)`. No exceptions.
- Without `@Push`, `ui.access` changes wait for the next user interaction to appear —
  the classic "answer shows up only when I click something" bug.
- Guard long-lived subscriptions with `ui.isAttached()`; user may close the tab
  mid-generation. Detached-UI access throws or silently leaks.

## 3. Streaming tokens into the chat (Spring AI `.stream()` + Vaadin)

```java
UI ui = UI.getCurrent();
Paragraph bubble = new Paragraph();
messageList.add(bubble);
chatClient.prompt().user(q).stream().content()      // Flux<String>
    .subscribe(
        token -> ui.access(() -> bubble.setText(bubble.getText() + token)),
        err   -> ui.access(() -> bubble.setText("Something went wrong — try again.")),
        ()    -> ui.access(() -> enableInput()));
```

- Consider batching tokens (e.g. buffer 50-100ms) — one `ui.access` per token can flood
  the push channel on long answers.
- Always handle the error signal with a user-friendly message; a silent dead bubble
  looks like a frozen app.

## 4. Scopes — where conversation state may live

| State | Correct home |
|---|---|
| Current conversation / chat memory id | `@UIScope` bean (per tab) or `@VaadinSessionScope` (per user session) |
| Cross-request services (ChatClient, tool beans) | normal singletons — but **stateless** |
| Anything in a singleton's mutable field | 🐛 users will see each other's data under load |

`@UIScope` + `@SpringComponent` for views/components; inject services into them.
The "second user gets first user's chat" bug is always a scope mistake — check here first.

## 5. Browser boundary — STT / TTS / avatar

The microphone and speakers are in the **browser**; the server never hears audio.

- **JS in:** `@JsModule("./audio-recorder.js")` loads a client module;
  `element.executeJs("...")` invokes it; it calls back via
  `element.$server.onAudioChunk(...)` → a Java method annotated `@ClientCallable`.
- **Audio out (TTS):** stream/serve audio bytes (e.g. `StreamResource`) and play via a
  JS `Audio` object or `<audio>` element; or generate client-side if using a browser API.
- **Avatar/3D:** wrap the JS widget as a Web Component or drive it with `executeJs`;
  keep the animation loop client-side, send only high-level cues (visemes/expressions)
  from the server — never per-frame data over push.
- Debugging this layer = browser devtools console first, server logs second.

## 6. Long-operation UX (make the app feel alive during AI calls)

- Disable the send button + show a typing indicator immediately (request thread),
  re-enable in the async completion (`ui.access`).
- Set timeouts on the AI call and surface a retry affordance — an infinite spinner is
  how users learn to distrust the app.
- For multi-second tool executions (topology reads, report generation), push interim
  status lines ("Reading topology…") — cheap, and users forgive latency they can see.

## 7. Pitfall table

| Symptom | Usual cause |
|---|---|
| Answer appears only after clicking somewhere | `@Push` missing |
| `IllegalStateException: UI instance is not available` / NPE on `UI.getCurrent()` | captured UI on the wrong thread — capture before async |
| Users see each other's chat/history | conversation state in a singleton field, or ChatMemory keyed by a shared id (see spring-ai-mentor §3) |
| UI freezes during AI call | blocking LLM call on the request/UI thread — go async |
| Updates stop after a while | detached UI still subscribed — check `ui.isAttached()`, dispose subscriptions on detach |
| Memory creep | listeners/subscriptions holding `UI`/component refs past detach |
| Session serialization errors on cluster | non-serializable state (e.g. a ChatClient) stored in session-scoped beans — inject, don't store |

## 8. Testing

- Logic out of views: keep views thin, push behavior into plain services (testable
  without a browser).
- [karibu-testing](https://github.com/mvysny/karibu-testing) unit-tests Vaadin UIs
  without a browser — good fit for chat-panel behavior (send → bubble appears).
- For push/async flows, integration-test the service layer with a stubbed ChatModel
  (spring-ai-mentor §8) and trust `ui.access` plumbing to a couple of manual checks.
