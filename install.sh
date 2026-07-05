#!/usr/bin/env bash
# Install muse-dev-skills into Claude Code (home) and/or Windsurf (work).
#
#   ./install.sh claude              # → ~/.claude/skills/
#   ./install.sh windsurf <repo>     # → <repo>/.windsurf/{workflows,rules}/ + local .agent/ ignore
#   ./install.sh windsurf-global     # → ~/.codeium/windsurf/global_workflows/
set -euo pipefail
cd "$(dirname "$0")"

SKILLS=(feature-brief domain-tutor impl-log explain-before-merge spring-ai-mentor token-sniper standup-reporter stuck-protocol)

case "${1:-}" in
  claude)
    mkdir -p ~/.claude/skills
    for s in "${SKILLS[@]}"; do cp -r "$s" ~/.claude/skills/; done
    echo "Installed ${#SKILLS[@]} skills to ~/.claude/skills/ — invoke with /feature-brief etc."
    ;;
  windsurf)
    repo="${2:?usage: ./install.sh windsurf <path-to-work-repo>}"
    mkdir -p "$repo/.windsurf/workflows" "$repo/.windsurf/rules"
    cp windsurf/workflows/*.md "$repo/.windsurf/workflows/"
    cp windsurf/rules/*.md     "$repo/.windsurf/rules/"
    if [ -d "$repo/.git" ] && ! grep -q '^\.agent/$' "$repo/.git/info/exclude" 2>/dev/null; then
      echo ".agent/" >> "$repo/.git/info/exclude"
      echo "Added .agent/ to $repo/.git/info/exclude (local-only ignore)."
    fi
    echo "Installed workflows+rules into $repo/.windsurf/ — invoke with /brief, /verify, /log, /tutor, /standup."
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
