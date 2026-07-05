# Log NNN: [Task name]
**Status:** [IN PROGRESS]   **Brief:** [briefs/NNN-….md]   **Started:** YYYY-MM-DD

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
