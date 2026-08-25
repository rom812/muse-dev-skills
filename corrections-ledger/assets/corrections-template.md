# Corrections Ledger

Every correction, once. Newest first. Read the **Rule** column before every PR and demo
(`/ledger check`).

> Private — lives in `.agent/`, never pushed to a personal repo.

## Active rules (the fast read)

One line per rule, newest first. This is what `check` mode reads.

| # | Rule | Applies when | Fired |
|---|------|--------------|-------|
| 3 | Before writing any type-to-display conversion, grep for an existing `*Converter` / `*Mapper` / `*Formatter` in the UI module (`precedent-check`) | Writing any mapping between a domain type and a UI string | 1 |
| 2 | Name the emitting service in the brief before tracing notification behaviour | Any task touching topology notifications | 1 |
| 1 | Send a Teams message with a default-and-deadline instead of waiting for a reply | Blocked on a decision from Danny for >1 day | 2 ⚠ |

## Entries

### 2026-07-24 · Danny (PR comment)

- **What I did:** Wrote a new `StatusLabelMapper` to turn the entity status enum into
  the string shown in the UI table.
- **What they said:** "We already have `EntityStatusConverter` for this — it's used in
  three other views. Please don't add a second one."
- **The rule:** Before writing any type-to-display conversion, grep for an existing
  `*Converter` / `*Mapper` / `*Formatter` in the UI module before writing a new one.
- **Applies when:** Writing any mapping between a domain type and a UI string.
- **Status:** first occurrence → promoted to `precedent-check` as a named search pattern.

<!--
### YYYY-MM-DD · Who (channel)

- **What I did:**
- **What they said:** "…"
- **The rule:**
- **Applies when:**
- **Status:** first occurrence | ⚠ REPEAT of rule #N → promoted to <where>
-->

## Themes (filled during `/ledger review`)

Three or more rules under one theme is one missing habit, not three mistakes.

| Theme | Rules | The habit that would have prevented all of them |
|-------|-------|-------------------------------------------------|
| Reinventing existing utilities | #3 | Run `precedent-check` before any new helper |
| Waiting instead of escalating | #1 | Default-and-deadline on every open decision |
