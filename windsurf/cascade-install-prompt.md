# Cascade Installation Prompt

Paste this into Cascade (Windsurf) to have it install/update the workflows, rules,
references, and context-pack script into the current work project. Assumes the
muse-dev-skills repo is already cloned somewhere on the machine.

(Cheaper alternative: run steps 1–3 yourself in the VM terminal — zero credits.)

```
You are doing a mechanical installation task. Follow these steps exactly, using
terminal commands. Do not improvise, do not create or edit any files yourself,
do not touch anything outside the listed steps.

CONTEXT
- "SKILLS_REPO" = the folder where the git repo muse-dev-skills is cloned on this
  machine. Find it (check ~/, ~/repos, ~/projects, the workspace parent folder).
  If you cannot find it, STOP and ask me for the path — do not clone anything.
- "WORK_REPO" = the root folder of the currently open workspace (the Muse project).
- NOTE: some or all workflows/rules/references are ALREADY INSTALLED from a previous
  run. That is expected — this run UPDATES them by overwriting. Do not treat existing
  files as an error and do not skip the install because files exist.

STEPS
1. cd SKILLS_REPO && git pull
   (must succeed — if pull fails, STOP and show me the error)
2. chmod +x install.sh
3. ./install.sh windsurf WORK_REPO   (use the absolute path)

VERIFY — show me the raw output of all five:
4. ls WORK_REPO/.windsurf/workflows/
5. ls WORK_REPO/.windsurf/rules/
6. ls WORK_REPO/.agent/reference/ && ls WORK_REPO/.agent/context-pack.sh
7. ls WORK_REPO/.agent/reference/copilot-agents/
8. cat WORK_REPO/.git/info/exclude

EXPECTED
- 10 workflow files: brainstorm.md, brief.md, log.md, map.md, plan.md, standup.md,
  stuck.md, trace.md, tutor.md, verify.md
- 1 rules file: ai-discipline.md
- 4 reference files (spring-ai-patterns, vaadin-patterns, weak-model-playbook,
  copilot-session-prompts) + context-pack.sh in .agent/
- copilot-agents/: 6 agent templates + README.md; any *.refined.md files were
  NOT touched (they are work-side refinements)
- ".agent/" present in .git/info/exclude

Report PASS or list every mismatch. Do nothing else.
```

After PASS: open the Customizations panel → Workflows, confirm the ten commands
appear, then smoke-test with `/brief`.

> Why this prompt is shaped this way (reusable pattern for any Cascade chore):
> context with discovery rules → numbered steps → STOP conditions → verification
> with expected output → "do nothing else."
