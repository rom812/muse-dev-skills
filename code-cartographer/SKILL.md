---
name: code-cartographer
description: 'Build and maintain living maps of a multi-repo system: one compact CODEMAP per repo (modules → purpose → key classes → talks-to) and one cross-repo SYSTEM-MAP (which repo talks to which, over what). Incremental — one area per session. Use when asking where something lives across repos, when a blast-radius can''t be answered, or when entering an unmapped repo or module.'
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion, mcp__serena__get_symbols_overview, mcp__serena__find_symbol, mcp__serena__find_referencing_symbols, mcp__octocode__localViewStructure, mcp__octocode__localSearchCode
---

# Code Cartographer

For a system of several large repos where no single person (least of all a newcomer)
holds the whole picture. Produces two living artifacts: **CODEMAP-<repo>.md** per repo
and one **SYSTEM-MAP.md** for the edges between them. The maps then feed everything
else: blast-radius in `feature-brief`, the neighborhood layer in `domain-tutor`, and
context packs in `copilot-bridge` (a 100-line system map beats 3,000 raw lines).

Core discipline: **maps are drawn lazily, one area per session** — mapping five big
repos up front is how this dies in week one. Free recon does the heavy lifting; AI
turns are spent only on *inferring purpose*.

## When this triggers

- "Where does X live / who consumes Y across our repos?"
- A `feature-brief` blast-radius (Step 3) can't be answered from existing maps.
- The user enters a repo or module with no CODEMAP entry yet.
- A map turned out wrong or stale during a task.
- The user invokes `/code-cartographer` or `/map`.

## When this does not trigger

- Understanding one *concept* (an entity, a flow's meaning) → `domain-tutor` —
  cartographer says where things are and what they're for; tutor teaches what they mean.
- Following ONE runtime flow step-by-step ("what happens when X?") → `flow-tracer` —
  the map is the atlas; a trace is one verified route drawn on it.
- A one-time narrative onboarding guide for a single repo → the `codebase-onboarding`
  companion skill; cartographer maintains living maps, not a document you read once.
- Decomposing a briefed task → `task-planner`.

## Required inputs

- **Scope for this session:** ONE repo area/module (ask via interactive multi-choice
  if unclear — offer the unmapped areas as options). Never "map everything".
- **Map home:** `.agent/knowledge/codemaps/` in the primary repo (one folder for the
  whole system — maps of all repos live together).
- **Available engines** (best available wins): the editor's semantic index (Windsurf
  multi-root workspace — the one-time prerequisite: add all repos via File → Add
  Folder to Workspace), Serena/LSP symbol tools, plain grep/tree as the floor.

## Workflow

### Step 1 — Free recon (zero AI cost)
Terminal/tools only: directory tree top 2 levels · build manifests (`pom.xml` modules,
dependencies between the repos' artifacts) · entry points (main classes, `@RestController`,
`@EventListener`, `@Scheduled`, message listeners) · config files naming other systems
(URLs, topics, queues). Paste-ready facts, no interpretation yet.

### Step 2 — Infer purpose (the only AI step; one module at a time)
For each module in the scoped area: read entry points + 1-2 central classes (semantic
search or `find_symbol` to locate them) and write ONE purpose line in the user's own
words, plus key classes and what the module talks to. Unverified inferences get `⚠`.

### Step 3 — Record the CODEMAP
Update `CODEMAP-<repo>.md` from `assets/codemap-template.md`: modules table
(path → purpose → key classes → talks to), area date-stamped. Keep the whole map
≤150 lines — it's a map, not documentation; link to code/wiki, don't duplicate them.

### Step 4 — Harvest cross-repo edges
Any "talks to" that crosses a repo boundary goes into `SYSTEM-MAP.md`
(`assets/system-map-template.md`): source repo → target repo · mechanism (REST /
events / shared DB / library) · one-sentence contract · **code anchor** (the class or
config file proving the edge). No edge without an anchor — inferred edges are how
maps lie.

### Step 5 — Close the loop
Report what got mapped and the open `⚠` items (each is a 2-minute verification or a
question-slot candidate). If a mapped fact contradicted an assumption in an active
brief, flag the brief.

## Decision gates

- One area per session — if the user asks for more, map the one blocking today's task
  and list the rest as options for next time.
- No SYSTEM-MAP edge without a code anchor.
- A map found wrong during a task gets fixed immediately — a stale map is worse than
  no map, because it's trusted.
- Confidentiality: maps ARE internal architecture — they live in the work `.agent/`
  only, never in a public personal repo, never pasted to personal AI accounts.

## Output format

Persistent artifacts: `CODEMAP-<repo>.md` files + `SYSTEM-MAP.md` under
`.agent/knowledge/codemaps/`. In chat: what was mapped this session, the new/changed
edges, and the `⚠ verify` list.

## Gotchas

- Boiling the ocean is the death mode — the map grows one task-driven area at a time.
- Purpose lines in the user's own words; a copy-pasted class comment teaches nothing
  and is usually stale anyway.
- Date-stamp per area, not per file — you'll trust the June areas differently in December.
- The maps double as Copilot pack material: `SYSTEM-MAP.md` belongs in every
  cross-repo planning pack (`copilot-bridge`).

## Evaluation checklist

- [ ] Session scoped to one area, chosen via interactive options?
- [ ] Recon done free (tree/manifests/entry points) before any AI inference?
- [ ] Every module has a one-line purpose in the user's words; inferences marked `⚠`?
- [ ] Every cross-repo edge has mechanism + contract + code anchor?
- [ ] Maps within size budget, area date-stamped, `⚠` list reported?

## Assets

- `assets/codemap-template.md` — the per-repo map structure.
- `assets/system-map-template.md` — the cross-repo edge table.
