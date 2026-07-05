# Copilot Session Prompts (copy-paste, fill the [brackets])

## 1. Session opener (start EVERY fresh chat with this + the pack)

```
You are helping me develop a feature in a codebase you cannot access directly.
Below is a context pack: project brief, current task, latest implementation log,
and the relevant files. Treat the pack as the source of truth — where your general
knowledge conflicts with it, the pack wins.

Stack anchors: Spring Boot 3, Spring AI 1.0 (@Tool/@ToolParam API — NOT the old
FunctionCallback API), Vaadin 24 Flow (server-side UI; background threads must use
ui.access() with @Push; conversation state in UI/session-scoped beans).

After reading the pack: (1) state your understanding of the current task in 3
sentences, (2) list what's missing from the pack that you'd need to answer well.
Do not propose solutions yet.

[PASTE .agent/context-pack.md]
```

## 2. Planning (after the opener, gaps fixed)

```
Design the implementation for the current task. Output:
1. Files to change/create (best guess from the pack; flag uncertainty)
2. Steps in order, each small enough for one focused code generation
3. Which existing precedent in the pack each step should imitate
4. Risks / edge cases specific to this stack (async→UI, scopes, tool descriptions, timeouts)
5. What I should ask my boss before starting, if anything
Do not write implementation code.
```

## 3. Explain code (paste the file/method in or reference the pack)

```
Explain [class/method] from the pack: purpose, inputs/outputs, and one end-to-end
trace of [concrete scenario]. Max 300 words. Flag anything that looks unusual or
risky. If the pack doesn't contain enough to be sure, say what's missing instead
of guessing.
```

## 4. Diff review (before running /verify in the VM)

```
Review this diff as a strict senior reviewer. The intent is: [1 sentence from brief].
Check: correctness vs intent, error paths, Vaadin threading (ui.access/@Push),
bean scope/state bugs, missing timeouts, hardcoded config. For each finding:
severity, line, why, fix. Then list the 3 questions a reviewer is most likely to
ask me about this diff, with good answers.

[PASTE git diff]
```

## 5. Handoff — draft the Windsurf prompt (end of session, the payoff step)

```
Now write the exact prompt I should give to a weaker AI coding agent that HAS full
repo access, to implement step [N] of your plan. The agent is weak at reasoning
and strong at imitating. The prompt must include: the goal in one sentence; exact
files to read first; the precedent file/pattern to imitate; constraints (only
touch X, no refactoring, no TODOs, config to application.yml); expected output
(full file contents + what to test). Keep it under 250 words.
```

## 6. Distill a long report/log (when the VM agent produced walls of text)

```
Below is a long report from a coding agent. Distill it to: (1) what was actually
done, (2) what failed or is unverified, (3) decisions taken and why, (4) open
questions. Max 200 words. I'll use this distillation as context in future sessions
instead of the full report.

[PASTE report]
```
