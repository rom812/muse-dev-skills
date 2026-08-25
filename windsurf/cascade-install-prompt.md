# Windsurf / Devin Desktop Install & Reinstall Prompt

Paste this into the agent panel (Cascade or Devin Local) to install **or upgrade** the
skills, workflows, rules, references, and context-pack script in the current work
project. Assumes the muse-dev-skills repo is already cloned somewhere on the machine.

Re-running is the supported upgrade path: the installer **replaces** every skill it
manages, **prunes** skills it installed on a previous run that are no longer shipped,
and writes a manifest so you can prove the new version actually landed.

(Cheaper alternative: run steps 1–4 yourself in the VM terminal — zero credits.)

```
You are doing a mechanical installation task. Follow these steps exactly, using
terminal commands. Do not improvise, do not create or edit any files yourself,
do not touch anything outside the listed steps.

CONTEXT
- "SKILLS_REPO" = the folder where the git repo muse-dev-skills is cloned on this
  machine. Find it (check ~/, ~/repos, ~/projects, the workspace parent folder).
  If you cannot find it, STOP and ask me for the path — do not clone anything.
- "WORK_REPO" = the root folder of the currently open workspace (the Muse project).
- THIS IS A REINSTALL. Some or all skills/workflows/rules/references are ALREADY
  INSTALLED from a previous run. That is expected and is the point: this run REPLACES
  the old versions with the new ones. Do not treat existing files as an error, do not
  skip the install because files exist, and do not try to merge old and new by hand —
  the installer overwrites, and that is correct.

STEPS
1. cat WORK_REPO/.agent/muse-manifest 2>/dev/null || echo "NO PREVIOUS INSTALL"
   (record the old version_sha — this is what we are replacing)
2. cd SKILLS_REPO && git pull
   (must succeed — if pull fails, STOP and show me the error)
3. chmod +x install.sh
4. ./install.sh windsurf WORK_REPO   (use the absolute path)

VERIFY — show me the raw output of all seven:
5. cat WORK_REPO/.agent/muse-manifest
6. cd SKILLS_REPO && git rev-parse --short HEAD
7. ls WORK_REPO/.windsurf/skills/
8. ls WORK_REPO/.windsurf/workflows/ && ls WORK_REPO/.windsurf/rules/
9. ls WORK_REPO/.agent/reference/ && ls WORK_REPO/.agent/context-pack.sh
10. ls WORK_REPO/.agent/reference/copilot-agents/
11. cat WORK_REPO/.git/info/exclude

EXPECTED
- THE REPLACEMENT PROOF: version_sha in the manifest (step 5) is IDENTICAL to the repo
  HEAD from step 6. If they differ, the install did not take — report FAIL. A skill
  directory merely existing proves nothing; only the matching SHA proves it is current.
- 17 skill directories, each containing SKILL.md: brainstorm, code-cartographer,
  copilot-bridge, corrections-ledger, demo-prep, domain-tutor, explain-before-merge,
  feature-brief, flow-tracer, impl-log, precedent-check, spring-ai-mentor,
  standup-reporter, stuck-protocol, task-planner, token-sniper, vaadin-mentor
- 15 workflow shim files: brainstorm, bridge, brief, demo, ledger, log, map, plan,
  precedent, sniper, standup, stuck, trace, tutor, verify
- 3 rules files: ai-discipline.md, spring-ai.md, vaadin.md
- 4 reference files (spring-ai-patterns, vaadin-patterns, weak-model-playbook,
  copilot-session-prompts) + context-pack.sh in .agent/
- copilot-agents/: 6 agent templates + README.md; any *.refined.md files were
  NOT touched (they are work-side refinements)
- ".agent/" present in .git/info/exclude
- If the installer printed any "Pruned retired skill: X" lines, list them — those are
  skills an older version shipped that no longer exist, and removing them is correct.

Report PASS or list every mismatch. Do nothing else.
```

After PASS, confirm which agent this build runs — **Cascade (legacy)** or **Devin Local**
(the Agent panel says which; Devin Local is the default since 2026-07-01, but on
Enterprise plans it is gated behind an admin toggle, so a work install may still be
Cascade):

- **Devin Local** → skills run directly and can fire on their own. Open Customizations →
  Skills, confirm 17 appear, smoke-test with `/brief`. The workflow shims are harmless
  spares; Devin Local ignores workflows entirely.
- **Cascade (legacy)** → skills are `@mention`-or-model-invoked only, so the slash
  commands come from the shims. Open Customizations → Workflows, confirm the 15 commands
  appear, then smoke-test with `/brief`.

If the skill list still shows the old set after a PASS, reload the workspace — both
agents pick up skill changes on the next interaction, but a stale panel can cache the
previous list.

> Why this prompt is shaped this way (reusable pattern for any agent chore):
> context with discovery rules → numbered steps → STOP conditions → verification with
> expected output → a **falsifiable** success criterion (the SHA match, not "the files
> are there") → "do nothing else."
