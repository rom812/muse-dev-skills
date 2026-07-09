# Log NNN: [Task name]
**Type:** IMPL   **Status:** [IN PROGRESS]   **Started:** YYYY-MM-DD
**Brief:** [.agent/briefs/NNN-….md]   **Related logs:** [DL-NNN / log NNN, or "None"]

## Description
[2-4 self-contained lines: what this task is, which services/classes/endpoints it
touches, and the outcome once shipped. A future session reads ONLY this section to
decide if the log is relevant — write it for that reader.]
**Keywords:** [grep bait — feature name, class names, endpoints, error strings]

## Generations
| # | Prompt (gist) | Got | Verified by | Trust |
|---|---------------|-----|-------------|-------|
| 1 | [what I asked] | [what it made] | [test/trace/manual] | understood / mostly / ⚠ magic |

## Decision record (my answers for "why did you implement it like that?")
| Choice made | Alternative(s) considered | Why this one |
|-------------|--------------------------|--------------|
| [e.g. used @Async job instead of sync call] | [sync in request thread] | [LLM call takes seconds; precedent in XJob.java] |

## Fix cycles
| # | What broke | Root cause | Wrong assumption I made |
|---|-----------|------------|------------------------|
| 1 | […] | […] | […] |

## Shipped
- **Date:** YYYY-MM-DD   **Acceptance criteria:** [all checked in brief? y/n]
- **How I proved it works:** […]

## What I learned
[One honest paragraph — technical + process]

## Reusable
- [pattern / snippet / gotcha worth remembering — promote to knowledge note if big]
