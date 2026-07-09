---
description: Map one repo area into the living CODEMAP + cross-repo SYSTEM-MAP (incremental, free-recon-first)
---

# /map — Code Cartographer

Maps live in .agent/knowledge/codemaps/ (CODEMAP-<repo>.md per repo + SYSTEM-MAP.md).
Prerequisite (one-time): all repos added to this workspace via File → Add Folder to
Workspace, so retrieval spans the whole system.

1. Scope: ask me which ONE area/module to map — suggested-responses options listing
   unmapped areas (prefer the one blocking my current task). Never map everything.
2. Free recon via terminal (no generation): tree top 2 levels · pom.xml modules and
   cross-repo dependencies · entry points (grep for @RestController, @EventListener,
   @Scheduled, main classes, message listeners) · configs naming other systems
   (URLs/topics/queues).
3. Infer purpose, one module at a time: read entry points + 1-2 central classes, write
   ONE purpose line in MY words (make me rephrase), key classes, talks-to. Mark
   unverified inference with ⚠.
4. Update CODEMAP-<repo>.md (modules table: path | purpose | key classes | talks to |
   date). Keep the whole file ≤150 lines — link, don't duplicate.
5. Cross-repo "talks to" edges → SYSTEM-MAP.md row: from | to | mechanism
   (REST/events/DB/lib) | one-sentence contract | CODE ANCHOR (class/config proving
   it) | date. No edge without an anchor.
6. Report: what got mapped, new/changed edges, and the ⚠ list (each ⚠ = a 2-minute
   verification or a question-slot item).

Rules: maps are internal architecture — they stay in this work environment. A map
proven wrong during a task gets fixed on the spot. SYSTEM-MAP.md belongs in every
cross-repo Copilot context pack.
