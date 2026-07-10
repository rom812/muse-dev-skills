# Copilot Custom Agents — templates

Six persistent system prompts for the unlimited chat-only work Copilot, one per
recurring job in the master loop. These are **templates**: generic, public-safe,
full of `{{PLACEHOLDERS}}`.

## The deployment flow

1. `install.sh windsurf <repo>` ships these files to `<repo>/.agent/reference/copilot-agents/`.
2. At work, tell the in-repo coding agent (Cascade):
   *"Refine every template in .agent/reference/copilot-agents/ per its REFINE-ME
   section — write each result to <name>.refined.md in the same folder."*
3. Paste each refined prompt into a Copilot custom agent's instructions field.
4. **Refined copies contain internal details. They live in `.agent/` (git-excluded)
   and are NEVER committed back to this public repo.**

## Shared design rules (baked into every prompt)

- Stateless sessions: every conversation starts with a pasted context pack
  (`context-pack.sh`); the agent never assumes memory.
- No repo access: the agent works only from pasted material and must ask for
  missing files by exact name, batched in ONE numbered list.
- Unknown = say so: guesses are marked `⚠ assumption`, never stated as fact.
- Output is always copy-pasteable and telegraphic — it feeds a human with 5 minutes,
  a weak IDE model, or an `.agent/` note.
- Keep every refined prompt ≤ 8,000 characters (Copilot instruction limit).

## The agents

| File | Agent | Job |
|------|-------|-----|
| 01-design-partner.md | Design Partner | approaches + trade-offs + boss questions; red-teams design docs before review |
| 02-prompt-smith.md | Prompt Smith | one plan step → one surgical prompt for the weak in-IDE model |
| 03-diff-reviewer.md | Diff Reviewer | severity-ranked diff review + review-defense + PR description |
| 04-code-explainer.md | Code Explainer | pasted code → explanation + draft /trace chain with ⚠ markers |
| 05-bug-hypothesizer.md | Bug Hypothesizer | error + code → ranked root-cause hypotheses + discriminating checks |
| 06-comms-officer.md | Comms Officer | raw notes → senior-shaped messages (default+deadline, minutes, wins) |
