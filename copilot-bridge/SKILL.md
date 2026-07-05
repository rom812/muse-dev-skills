---
name: copilot-bridge
description: 'Protocol for using an unlimited chat-only strong model (e.g. work Copilot/GPT) as the planning brain for a codebase it cannot access: maintain a context pack instead of pasting raw code, stateless sessions, and structured handoff prompts to the in-repo coding agent. Use when working with a chat AI that has no repository access.'
---

# Copilot Bridge

Setup this solves: the strong unlimited model (Copilot GPT on the Windows host) can't
see the repo; the agent that CAN see the repo (Windsurf on the Linux VM) is weak and
credit-limited. Naive bridging — pasting thousands of raw lines per chat — drowns the
strong model in noise and can't be kept current.

The fix rests on two principles:

1. **Maintain documents, not conversations.** A chat has no memory and degrades as it
   grows. Stop trying to keep one long Copilot chat "updated" — keep a small, curated
   **context pack** updated instead, and start a fresh session from it each time.
   Fresh session + good pack beats a stale mega-chat every single time.
2. **Distill, don't dump.** For planning and design questions, a 200-line map of the
   system outperforms 3,000 raw lines — signal-to-noise governs answer quality. Raw
   code goes into the pack only for the files actually under discussion.

## The three standing documents (live in `<work-repo>/.agent/`)

| Document | Contents | Update cadence |
|---|---|---|
| `PROJECT-BRIEF.md` | 1 page: what the app is, stack + versions, module map, key flows | rarely — on architecture change |
| current feature brief | the task's `/brief` output | per task |
| latest impl-log | current state: what's generated, verified, broken | continuously (you already do) |

Bootstrap `PROJECT-BRIEF.md` once, cheaply: paste the repo's directory tree + main
class names into Copilot and co-write it ("draft a 1-page project brief from this
structure; I'll correct it"). Correcting its draft is itself a domain-learning exercise.

**The paper trail you already keep IS the memory of the bridge** — briefs, logs, and
decision records are exactly what keeps a stateless strong model current for pennies.

## The pack generator

`scripts/context-pack.sh` (run in the VM terminal, costs zero credits):

```bash
./context-pack.sh src/main/java/.../LinkEventTools.java src/main/java/.../ChatView.java
```

Concatenates into `.agent/context-pack.md`: project brief → current task brief →
latest impl-log → uncommitted diff (truncated) → the named files, fenced and labeled.
Prints a token estimate and warns when the pack gets bloated. One file → one
copy-paste (or file upload) into Copilot.

## Session protocol

1. Generate the pack; start a **fresh** Copilot chat (never continue yesterday's).
2. Open with the session-opener prompt (`assets/copilot-session-prompts.md`) — it makes
   the model (a) treat the pack as source of truth over its assumptions, (b) state its
   understanding back in 3 sentences, and (c) list what's missing. Fix gaps before
   asking your real question; a model that starts wrong stays wrong.
3. Work the question: planning, design options, explain-this-code, diff review,
   report distillation (prompts for each in the assets file).
4. **End with the handoff**: have the strong model draft the token-sniper one-shot
   prompt for Windsurf — it knows the plan it just made, and a strong model writes
   better prompts for a weak model than you can by hand. You paste that into Cascade.
   The strong model plans; the weak model only types.
5. Anything durable the session produced (a decision, a domain explanation) goes into
   the impl-log / a knowledge note — the chat itself is disposable.

## Division of labor (the full triangle)

- **Copilot GPT (unlimited, no repo):** planning, architecture options, explaining
  pasted code, reviewing diffs BEFORE /verify, distilling long agent reports, drafting
  Windsurf prompts, rehearsing review-defense answers.
- **Windsurf (repo, 1000 credits):** executing prepared prompts — generation and
  multi-file edits only.
- **Claude home (unlimited, never sees work code):** domain concepts abstractly,
  skill/workflow maintenance, career strategy.

## Rules

- ⚠ **Verify which Copilot you have before pasting any source code**: enterprise
  Copilot with commercial data protection (green shield / work account) is typically
  sanctioned for company code; a consumer/personal-account Copilot is NOT. Confirm
  with IT once — this is a one-question, career-protecting check.
- Fresh chat per task or per day, whichever comes first. If the model gets confused,
  regenerate the pack and restart rather than arguing (weak-model playbook rule 6
  applies to strong models in long chats too).
- The trust ladder still applies (token-sniper playbook §defenses): GPT is stronger,
  not omniscient — claims about YOUR codebase still need the one-hop verification,
  because it only knows what the pack shows it.
- Don't let packs bloat past ~30k tokens: past that, quality drops and pasting becomes
  the bottleneck again. Trim the file list, not the standing documents.
