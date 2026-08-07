<!-- Paste this block into the work repo's AGENTS.md (create the file at the repo
root if it doesn't exist). Devin reads AGENTS.md automatically; Claude Code and
other AGENTS.md-aware agents do too. Delete this comment when pasting. -->

## Implementation logs — read before coding

If `.agent/design-logs/` exists in this repo, it contains indexed logs of prior
implementations and decisions. This repo is the workspace's SINGLE log home — never
create a `.agent/design-logs/` in another repo of this workspace or at the workspace
root; tasks touching sibling repos are logged here too. Before implementing any task:

1. Read `.agent/design-logs/INDEX.md` and note rows related to the task.
2. Read the matching feature's `.agent/design-logs/<feature>/INDEX.md` — its
   Snapshot lists the feature's current state, decisions in force, and gotchas.
3. Grep 3-6 task keywords across `.agent/design-logs/**` for cross-feature hits;
   read only the Description header (first ~15 lines) of candidates.
4. Follow decisions recorded there unless the task explicitly overrides them, and
   say which logs you are following before you start.

While implementing, keep the log updated per the `impl-log` skill: record each AI
generation (prompt gist · result · verification evidence · trust level), each fix
cycle, and refresh the feature Snapshot when the task ships. If the folder does not
exist, skip all of this silently.
