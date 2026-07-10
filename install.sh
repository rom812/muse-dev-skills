#!/usr/bin/env bash
# Install muse-dev-skills into Claude Code (home) and/or Windsurf (work).
#
#   ./install.sh claude              # → ~/.claude/skills/
#   ./install.sh windsurf <repo>     # → <repo>/.windsurf/{workflows,rules}/ + local .agent/ ignore
#   ./install.sh windsurf-global     # → ~/.codeium/windsurf/global_workflows/
set -euo pipefail
cd "$(dirname "$0")"

SKILLS=(feature-brief domain-tutor impl-log explain-before-merge spring-ai-mentor token-sniper standup-reporter stuck-protocol vaadin-mentor copilot-bridge brainstorm task-planner code-cartographer flow-tracer)

case "${1:-}" in
  claude)
    mkdir -p ~/.claude/skills
    for s in "${SKILLS[@]}"; do cp -r "$s" ~/.claude/skills/; done
    echo "Installed ${#SKILLS[@]} skills to ~/.claude/skills/ — invoke with /feature-brief etc."
    ;;
  windsurf)
    repo="${2:?usage: ./install.sh windsurf <path-to-work-repo>}"
    mkdir -p "$repo/.windsurf/workflows" "$repo/.windsurf/rules" "$repo/.agent/reference"
    cp windsurf/workflows/*.md "$repo/.windsurf/workflows/"
    cp windsurf/rules/*.md     "$repo/.windsurf/rules/"
    # pattern references — readable by Cascade as workspace files (see ai-discipline rule)
    cp spring-ai-mentor/references/spring-ai-patterns.md \
       vaadin-mentor/references/vaadin-patterns.md \
       token-sniper/references/weak-model-playbook.md \
       copilot-bridge/assets/copilot-session-prompts.md \
       "$repo/.agent/reference/"
    cp copilot-bridge/scripts/context-pack.sh "$repo/.agent/"
    chmod +x "$repo/.agent/context-pack.sh"
    # Copilot custom-agent templates — refined in-place at work (see agents/README.md)
    mkdir -p "$repo/.agent/reference/copilot-agents"
    cp copilot-bridge/agents/*.md "$repo/.agent/reference/copilot-agents/"
    if [ -d "$repo/.git" ] && ! grep -q '^\.agent/$' "$repo/.git/info/exclude" 2>/dev/null; then
      echo ".agent/" >> "$repo/.git/info/exclude"
      echo "Added .agent/ to $repo/.git/info/exclude (local-only ignore)."
    fi
    echo "Installed workflows+rules into $repo/.windsurf/, references+context-pack.sh into $repo/.agent/."
    echo "Invoke with /brief, /verify, /log, /tutor, /standup, /stuck."
    ;;
  windsurf-global)
    mkdir -p ~/.codeium/windsurf/global_workflows
    cp windsurf/workflows/*.md ~/.codeium/windsurf/global_workflows/
    echo "Installed workflows to ~/.codeium/windsurf/global_workflows/ (all projects)."
    ;;
  *)
    echo "usage: ./install.sh claude | windsurf <path-to-work-repo> | windsurf-global" >&2
    exit 1
    ;;
esac
