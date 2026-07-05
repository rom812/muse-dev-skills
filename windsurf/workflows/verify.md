---
description: Verification gate before committing AI-generated code — explain, trace, edge-cases, PR text
---

# /verify — Explain Before Merge

Rule: if I can't explain a line, I don't commit it. Run the gates in order.

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
4. **Test plan executed.** Map the change to the brief's acceptance criteria; prove each
   with a unit test, integration test, or a manual check actually performed now. Run the
   build + existing tests; record results.
5. **Output PR description** ready to paste:
   What (1-2 sentences) / Why (from brief) / How (3 bullets incl. which precedent it
   follows) / How I tested (checked boxes, concrete) / Notes for reviewer (the one spot
   deserving extra eyes, stated honestly).
6. Update `.agent/logs/NNN-*.md`: mark verified entries `understood`, log any fix cycle
   (what broke / root cause / which assumption was wrong).
