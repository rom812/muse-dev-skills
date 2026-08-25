---
trigger: always_on
---

# AI Discipline

## Skills first

This project ships skills in `.windsurf/skills/`. When a request matches one, run it
instead of improvising the process ad hoc:

new task → `feature-brief` · vague idea → `brainstorm` · multi-file plan → `task-planner` ·
before writing any new helper → `precedent-check` · about to commit → `explain-before-merge` ·
after generating / something broke / shipped → `impl-log` · "what happens when X?" →
`flow-tracer` · "where does X live?" → `code-cartographer` · concept I can't explain →
`domain-tutor` · stuck past a timebox → `stuck-protocol` · status update →
`standup-reporter` · corrected by anyone → `corrections-ledger` · demo or review coming →
`demo-prep`.

## Hard gates

- No code on a non-trivial task before a brief exists at `.agent/briefs/NNN-<task>.md`.
- No new util/converter/helper/mapper before `precedent-check` confirms one doesn't exist.
- No commit of AI-generated code before `explain-before-merge`.
- No task ends without its log at `.agent/design-logs/NNN-<task>.md`.

## Every response

- Batch ALL questions into ONE message as suggested-response / multi-choice options
  (always include an "other"). Never end a turn with an open free-text question when
  options are possible — every extra turn costs credits.
- Always imitate an existing precedent in this codebase (naming, error handling,
  layering) instead of inventing a new pattern.
- Delegate mechanical gathering — search, file discovery, call-chain tracing — to a
  read-only explore subagent. Keep the expensive model for judgment and generation.
- For non-trivial patterns, unfamiliar errors, or possibly-outdated APIs, run a quick
  Exa/Tavily search BEFORE generating. Search is far cheaper than a wrong implementation.
- Explain any non-obvious line in one sentence, and end every generation with a short
  "what to test to prove this works" list.
- Never leave placeholders, TODOs, or hardcoded values that belong in `application.yml`.
