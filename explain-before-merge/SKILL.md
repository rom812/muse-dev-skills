---
name: explain-before-merge
description: 'Verification gate for AI-generated code before commit: explain every changed line, trace the runtime flow, hunt edge cases, and produce a PR description with a real test plan. Use before committing any AI-assisted change.'
---

# Explain Before Merge

The hard gate that ends the "commit AI code → it breaks → fix → looks bad" cycle.

Core rule, borrowed from every senior engineer who survived AI adoption:
**treat AI output like code from a stranger — if you can't explain a line, you can't
commit it.** Plausible-looking is exactly where the subtle bugs hide.

## When this triggers

- An AI-assisted change is about to be committed.
- An impl-log has a `⚠ magic` generation entry.
- The user invokes `/explain-before-merge` or `/verify`.

## Protocol

### Gate 1 — Line accountability

Walk the diff hunk by hunk. For each hunk the user (not the AI) states in one sentence
*what it does and why it's needed*. Three possible outcomes per hunk:

- **Explained** → passes.
- **Can't explain** → the AI explains it, then the user re-states it in their own words.
  Still unclear → simplify the code until it IS explainable. Unexplainable code is a
  liability regardless of whether it works.
- **Explains it but it's wrong/unneeded** → congratulations, gate caught a bug for free.
  Fix, log the fix cycle in the impl-log.

### Gate 2 — Runtime trace

Trace ONE real scenario end-to-end through the new code, naming actual methods in order
(request/event in → … → observable result out). If the trace hits a method whose behavior
is a guess, stop and read it. For the Muse chatbot this usually means: chat message or
topology event in → tool selection → tool execution → response/report out.

### Gate 3 — Edge-case hunt (Spring Boot specific)

Check the classics AI code systematically omits:

- **Nulls/empties:** null params, empty lists, missing Optional handling
- **Error paths:** what happens when the downstream service/tool throws? Swallowed
  exceptions? User-facing error message vs stack trace?
- **Concurrency:** shared mutable state in singleton beans (`@Component`/`@Service`
  fields written per-request are a classic AI bug), `@Async` touching request-scoped data
- **Transactions:** `@Transactional` on the right layer? Self-invocation breaking the proxy?
- **Resources:** unclosed streams/clients, unbounded collections, missing timeouts on
  external calls (LLM calls especially — they hang)
- **Config:** hardcoded values that belong in `application.yml`

### Gate 4 — Test plan executed (not just written)

- Which acceptance criteria (from the brief) does this change satisfy? Prove each one:
  unit test, integration test, or a described manual check *actually performed*.
- Run the build + existing tests. Paste results into the impl-log's "Verified by".

### Output — PR description

Generate ready-to-paste PR text:

```
## What
[1-2 sentences]

## Why
[the problem, from the brief]

## How
[approach in 2-3 bullets, incl. which existing pattern it follows]

## How I tested
- [x] [concrete check 1]
- [x] [concrete check 2]

## Notes for reviewer
[the one place that deserves extra eyes, stated honestly]
```

The "How I tested" section filled with real checks is the single highest-signal
thing a junior can put in front of a reviewer.

## Rules

- Gates run in order; a failed gate loops back before proceeding.
- Update the impl-log: `⚠ magic` entries become `understood`, fixes get logged.
- 15 minutes on this gate is cheaper than one broken merge — both in time and reputation.
