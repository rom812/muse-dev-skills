#!/usr/bin/env bash
# Build a context pack for pasting into a chat AI that has no repo access (Copilot).
# Run from the project root on the VM. Costs zero AI credits.
#
#   ./context-pack.sh [file ...]        # pack standing docs + these source files
#   ./context-pack.sh --no-diff [file ...]   # skip the uncommitted-diff section
#
# Output: .agent/context-pack.md  (copy-paste or upload into the chat)
set -euo pipefail

OUT=".agent/context-pack.md"
INCLUDE_DIFF=1
[ "${1:-}" = "--no-diff" ] && { INCLUDE_DIFF=0; shift; }
mkdir -p .agent

{
  echo "# Context pack — $(date +%F) — branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'n/a')"
  echo

  if [ -f .agent/PROJECT-BRIEF.md ]; then
    echo "## Project brief"
    cat .agent/PROJECT-BRIEF.md
    echo
  else
    echo "> ⚠ No .agent/PROJECT-BRIEF.md yet — bootstrap it (see copilot-bridge SKILL.md)."
    echo
  fi

  if [ -f .agent/knowledge/codemaps/SYSTEM-MAP.md ]; then
    echo "## System map (cross-repo)"
    cat .agent/knowledge/codemaps/SYSTEM-MAP.md
    echo
  fi

  latest_brief=$(ls -1 .agent/briefs/*.md 2>/dev/null | sort | tail -1 || true)
  if [ -n "${latest_brief:-}" ]; then
    echo "## Current task — ${latest_brief}"
    cat "$latest_brief"
    echo
  fi

  latest_log=$(ls -1 .agent/design-logs/[0-9]*.md 2>/dev/null | sort | tail -1 || true)
  if [ -n "${latest_log:-}" ]; then
    echo "## Latest implementation log — ${latest_log}"
    cat "$latest_log"
    echo
  fi

  if [ "$INCLUDE_DIFF" = 1 ] && git rev-parse --git-dir >/dev/null 2>&1; then
    if ! git diff --quiet 2>/dev/null; then
      echo "## Uncommitted diff (first 400 lines)"
      echo '```diff'
      git diff | head -400
      echo '```'
      echo
    fi
  fi

  for f in "$@"; do
    if [ ! -f "$f" ]; then
      echo "⚠ skipped missing file: $f" >&2
      continue
    fi
    ext="${f##*.}"
    echo "## File: $f"
    echo "\`\`\`${ext}"
    cat "$f"
    echo '```'
    echo
  done
} > "$OUT"

chars=$(wc -c < "$OUT")
echo "Wrote $OUT  (~$((chars / 4)) tokens estimated)"
if [ "$chars" -gt 120000 ]; then
  echo "⚠ Pack is large (>~30k tokens) — quality drops. Trim the file list."
fi
