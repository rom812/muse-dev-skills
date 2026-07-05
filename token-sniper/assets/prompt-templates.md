# One-Shot Prompt Templates (fill offline, paste once)

## A. New feature / new logic

```
GOAL
[One sentence: when <trigger>, the system should <observable result>.]

CONTEXT
- Read these files first: [exact paths]
- Follow the pattern of: [precedent file — the nearest existing similar feature]
- Relevant domain fact: [one line from your knowledge note, own words]

CONSTRAINTS
- Spring AI version: [from pom.xml]; use [@Tool / .entity() / advisor] style as in the precedent
- Do not modify: [files/areas]
- Handle errors like [precedent] does; no hardcoded values (application.yml)

OUTPUT
- Files to create/modify with full contents
- One short paragraph explaining any non-obvious decision
- A list of what I should test to prove it works
```

## B. Bug fix (only after you gathered evidence)

```
BUG
- Expected: […]   Actual: […]
- Exact error/log: [paste]
- Where it happens: [class/method/line if known]
- My diagnosis: [your hypothesis — forces you to think, massively improves the fix]

SCOPE
Fix only this issue. Do not refactor. Explain the root cause in 2 sentences.
```

## C. Plan-only (cheap sanity check before a big task)

```
Do NOT write code. Read [files]. I need to [goal].
Output only: (1) files you would change, (2) steps in order,
(3) risks/things I might be missing, (4) which existing code should be imitated.
```

## D. Explain (prefer free sources first; use when only the AI has the context)

```
Explain what [class/flow] does in this codebase: purpose, inputs/outputs,
one end-to-end trace of [concrete scenario]. Max 300 words. No code changes.
```
