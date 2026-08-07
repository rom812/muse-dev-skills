# Feature: [feature-slug]

## Snapshot
[3-8 lines of CURRENT truth — rewrite on every ship, never append. What this feature
is, what state it is in, which decisions are in force (with log numbers), and any
active gotchas. An agent reads this before touching the feature; write it as that
agent's briefing.]

- **State:** [e.g. voice input shipped; TTS streaming in progress (log 021)]
- **Decisions in force:** [e.g. @Async for all LLM calls (log 014) · session-scoped chat memory (log 017)]
- **Gotchas:** [e.g. @Push breaks behind the corp proxy — see log 019 fix cycle 2]

## Logs
| NNN | Title | Type | Status | One-line description |
|-----|-------|------|--------|----------------------|
| [NNN] | [[Task name]](NNN-kebab-task.md) | IMPL | [IN PROGRESS] | [one line] |
