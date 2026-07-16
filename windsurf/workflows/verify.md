---
description: Verification gate before committing AI-generated code — explain, trace, edge-cases, PR text
---

# /verify — Explain Before Merge

Rule: if I can't explain a line, I don't commit it. Run the gates in order.
Use before every commit of AI-assisted code and after any /log entry marked `⚠ magic`.
Not for recording what happened (→ /log) or tracing an unfamiliar flow (→ /trace first).

1. **Line accountability.** Walk the diff hunk by hunk. For each, I state in one sentence
   what it does and why. If I can't: explain it to me, then make me restate it in my own
   words. If it's still unclear, simplify the code until it IS explainable. If my
   explanation reveals the hunk is wrong/unneeded — we just caught a bug; fix and note it.
2. **Runtime trace.** Trace ONE real scenario end-to-end through the new code, naming
   actual methods in order (chat message or topology event in → tool selection → tool
   execution → response/report out). Any method whose behavior is a guess → read it now.
3. **Edge-case hunt** (things AI code omits):
   - nulls/empty lists/missing Optional handling
   - error paths: downstream/tool throws → swallowed? user-facing message?
   - concurrency: mutable fields in @Service/@Component singletons; @Async + shared state
   - @Transactional on the right layer; self-invocation proxy trap
   - resources: unclosed clients, missing timeouts (LLM calls especially)
   - hardcoded values that belong in application.yml
   - Vaadin: components touched from async/AI threads must be inside ui.access() with
     @Push enabled + ui.isAttached() guard; conversation state in @UIScope beans, never
     singleton fields
4. **Test plan executed.** Map the change to the brief's acceptance criteria; prove each
   with a unit test, integration test, or a manual check actually performed now. Run the
   build + existing tests; record results.
5. **Review defense.** For each non-obvious choice in the diff, add a row to the
   impl-log decision table: choice / alternatives / why this one. If the AI chose,
   ask it for alternatives + rationale, verify the rationale against the code, and
   make me restate it in my own words. Predict the 3 lines the reviewer will question
   and rehearse answers. For anything undefendable, my fallback script is: "I followed
   the pattern from <precedent>; let me double-check that choice and get back to you
   today" — never bluff, never say "the AI did it".
6. **Output PR description** ready to paste:
   What (1-2 sentences) / Why (from brief) / How (3 bullets incl. which precedent it
   follows) / How I tested (checked boxes, concrete) / Notes for reviewer (the one spot
   deserving extra eyes, stated honestly).
7. Update the impl log at `.agent/design-logs/NNN-*.md` (run /log): mark verified entries
   `understood`, log any fix cycle (what broke / root cause / which assumption was wrong).
