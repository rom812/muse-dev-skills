# Trace: [Flow name]
**Entry point:** [POST /api/chat → ChatController.handleMessage()]
**Repos crossed:** [this repo only / → muse-topology-ms]
**Last verified:** YYYY-MM-DD   **Open ⚠:** [0 / N]

## Description
[2-3 self-contained lines: what this flow does end-to-end, what fires it, where it
stops. A future session reads ONLY this header to decide relevance.]
**Keywords:** [grep bait — endpoint, event name, key classes on the path]

## The chain
| # | Step (Class.method) | What happens / data shape | Boundary | Status |
|---|---------------------|---------------------------|----------|--------|
| 1 | [ChatController.handleMessage()] | [HTTP in: ChatRequest{sessionId, text}] | — | verified: read |
| 2 | [ChatService.process()] | [builds prompt + conversation memory] | — | verified: read |
| 3 | [ToolRegistry.select()] | [LLM picks @Tool by description] | async | ⚠ inferred |
| 4 | [→ topology-ms TopologyClient.getLinks()] | [REST GET /links → List<LinkDto>] | repo-hop | verified: debugger |

## Async / boundary notes
- [where the thread changes, which executor, what that means for state/UI/transactions]

## Gotchas found while tracing
- [surprises: self-invocation trap, config that reroutes X, exception swallowed at Y]

## Open ⚠
- [ ] [step 3 — confirm tool selection runs per-message, not per-session]
