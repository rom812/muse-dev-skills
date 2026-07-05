# Spring AI Patterns Reference

> Written against Spring AI **1.0.x** (GA, 2025). Always check the project's actual version
> in `pom.xml` — pre-1.0 milestones (0.8, M-versions) had different APIs
> (`FunctionCallback` era). Patterns below use the 1.0+ APIs.

## 1. ChatClient — the front door

```java
@Configuration
class AiConfig {
    @Bean
    ChatClient chatClient(ChatClient.Builder builder) {   // builder auto-configured by starter
        return builder
            .defaultSystem("You are the Muse assistant…")
            .build();
    }
}

// usage
String answer = chatClient.prompt()
    .user(userMessage)
    .call()
    .content();
```

- `.call()` = blocking, `.stream()` = Flux-based streaming.
- One `ChatClient` bean per "persona/configuration" is the common pattern; don't rebuild per request.

## 2. Tool calling (the chatbot's capabilities)

```java
class TopologyTools {
    @Tool(description = "Get the current network topology as a list of nodes and links. "
                      + "Use when the user asks about network structure, nodes, or links.")
    TopologySnapshot getTopology() { … }

    @Tool(description = "Create a report about a topology change event. "
                      + "eventId is the id from the topology event, e.g. 'link-deleted-42'.")
    String createReport(String eventId) { … }
}

// register: per-call or as default
chatClient.prompt().user(msg).tools(new TopologyTools()).call().content();
// or .defaultTools(...) on the builder
```

**The #1 lesson of tool calling: the model chooses tools ONLY from the descriptions.**
- Description says *what it returns* + *when to use it*. Vague description = tool never called
  or called wrongly. This is prompt engineering, not Java.
- Parameter names + `@ToolParam(description=…)` matter the same way.
- Too many tools (>~15-20) degrades selection; group or route if the list grows.
- Tool methods should return compact, LLM-readable data (summaries/DTOs), not entity dumps —
  everything returned is spent as context tokens.
- Need per-request state inside a tool (user id, tenant)? Use `ToolContext` — don't stash
  it in bean fields (concurrency bug, see §7).

## 3. Advisors — cross-cutting middleware for prompts

```java
builder.defaultAdvisors(
    MessageChatMemoryAdvisor.builder(chatMemory).build(),  // conversation history
    new SimpleLoggerAdvisor()                              // log requests/responses
)
```

- Memory: `MessageWindowChatMemory` keeps the last N messages; key every call with the
  conversation id: `.advisors(a -> a.param(ChatMemory.CONVERSATION_ID, sessionId))`.
- RAG: `QuestionAnswerAdvisor` (simple) / `RetrievalAugmentationAdvisor` (modular) pull
  from a `VectorStore` and inject context into the prompt.
- Custom advisors implement around-call interception — the right place for input
  sanitization, PII scrubbing, token accounting.

## 4. Structured output — never hand-parse LLM JSON

```java
record TopologyReport(String title, List<String> findings, Severity severity) {}

TopologyReport report = chatClient.prompt()
    .user("Summarize the link deletion event " + eventId)
    .call()
    .entity(TopologyReport.class);   // schema injected into prompt + parsed back
```

If you see hand-written `ObjectMapper.readValue(llmText…)` with regex cleanup — replace
with `.entity()`. For lists: `.entity(new ParameterizedTypeReference<List<X>>() {})`.

## 5. Event-driven AI jobs (the trigger pattern)

For "when X happens in the system, the AI does Y" (e.g., link deleted → generate report):

```
Domain event (Spring ApplicationEvent / message)
  → @EventListener / @TransactionalEventListener (AFTER_COMMIT if DB-derived)
    → job service builds a PROMPT from event data (template, not string concat)
      → chatClient call with the relevant tools
        → persist/dispatch the result; record job status
```

- Make AI jobs **async** (`@Async` or a queue) — LLM calls take seconds; never hold a
  request thread or a transaction open across one.
- Make them **idempotent** (event redelivery happens) and **bounded** (timeout + retry
  with cap; a hung LLM call must not wedge the job runner).
- Log the full prompt + response for every job run (that's the debuggability of the system).

## 6. Voice (STT/TTS) integration points

- Spring AI has model abstractions for transcription and speech
  (e.g., OpenAI-style `AudioTranscriptionModel` / speech model beans). Keep
  STT → chat → TTS as three separate steps around a normal text chat call — don't build
  a special "voice chat" path; reuse the text pipeline so tools/memory work identically.

## 7. Pitfall checklist (what breaks AI chatbot backends)

| Symptom | Usual cause |
|---|---|
| Model never calls my tool | Weak `@Tool` description; ambiguous overlap with another tool |
| Tool called with garbage args | Missing `@ToolParam` descriptions / non-obvious param names |
| Wrong/other user's data in answers | Conversation id not scoped per user/session; state in singleton bean fields |
| Random 30-60s hangs | No timeout on LLM/external calls |
| Works in test, breaks under load | Shared mutable state in `@Service` fields; LLM rate limits unhandled |
| JSON parse errors from LLM | Hand-parsing instead of `.entity()` |
| Costs/latency exploding | Tools returning huge payloads into context; unbounded chat memory |
| `@Transactional` weirdness | AI call inside a transaction, or self-invocation bypassing the proxy |

## 8. Testing patterns

- Unit-test tools as plain Java (they're just methods) — this is where most logic should live.
- For chat flows, inject a stubbed `ChatModel`/`ChatClient` returning canned responses;
  assert on the *prompt sent* and the *handling of the response*, not on live model output.
- One cheap integration test with the real model behind a profile/flag beats many flaky ones.
