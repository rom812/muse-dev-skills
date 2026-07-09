# CODEMAP — [repo name]
**One line:** [what this repo is for, my words]
**Build unit:** [maven artifact / service name]   **Runs as:** [service / library / UI]

## Modules
| Module/path | Purpose (my words) | Key classes | Talks to | Mapped |
|---|---|---|---|---|
| [src/…/topology] | [reads NE/link graph, publishes change events] | [TopologyService, LinkRepo] | [event bus → chatbot repo ⚠] | 2026-07 |

## Entry points
- **REST:** [controllers + one line each]
- **Events consumed / produced:** [listener → event type]
- **Jobs/schedulers:** […]

## ⚠ To verify
- [inferred, unproven statements — each is a 2-min check or a question-slot item]

> Rules: ≤150 lines total · link to code/wiki instead of duplicating · fix wrong
> entries the moment a task disproves them · date-stamp per area.
