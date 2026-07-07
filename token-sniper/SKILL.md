---
name: token-sniper
description: 'Discipline for spending a tiny monthly AI-credit budget surgically: decide if a task deserves credits, prepare a one-shot prompt offline, and never enter blind fix-loops. Use before any paid AI generation at work or when drafting prompts for a weaker model.'
allowed-tools: Read, Write, Edit, Grep, Glob
---

# Token Sniper

~1000 credits a month at work, on older models. Every credit spent on a lazy prompt or
a "still broken, fix it" loop is a credit not available when it matters. This skill
turns each generation into a **prepared, single, well-aimed shot**.

## When this triggers

- The user is about to use paid AI at work and wants the prompt prepared.
- The user is deciding whether a task is even worth credits.
- A previous generation failed and the user is tempted to reply "doesn't work, fix".
- The user invokes `/token-sniper`.

## When this does not trigger

- Understanding-phase work (what does X do, what does this term mean) — that's grep,
  wiki, `domain-tutor`, or free Copilot/home sessions; credits never buy comprehension.
- Planning with the unlimited chat model → `copilot-bridge` (which then hands off here).
- Framework-pattern questions → `spring-ai-mentor` / `vaadin-mentor` (their references
  feed this skill's prompts).

## Required inputs

- The goal, one sentence, from the brief's acceptance criteria.
- The precedent file/pattern to imitate (or the mentor-reference pattern to paste).
- Constraints: version anchors, files not to touch, conventions.

## Workflow

### Step 1 — Should this cost credits at all?
Find-where/how-it-works → grep/IDE/wiki (free) · domain terms → wiki/notes/home (free)
· boilerplate with a precedent → copy it by hand first · new logic in existing
patterns → ✅ one prepared shot · gnarly multi-file → plan first (Copilot/home), then
one prepared shot per step.

### Step 2 — Prepare the shot offline (costs nothing)
Fill a template from `assets/prompt-templates.md`: **Goal** (one sentence) · **Context**
(exact files; *the precedent to imitate* — weak models with a concrete example perform
like strong ones) · **Constraints** (version anchors, do-not-touch, error handling) ·
**Expected output** (files + "explain non-obvious lines") · **Verification** ("list
what I should test").
Working with the older work models specifically — and defending against being misled
by them — is `references/weak-model-playbook.md`: patterns > instructions, decompose
ruthlessly, fresh chat when confused, verification rules for output you can't yet judge.

### Step 3 — Fire once, then verify
Run the prompt, then go straight to `explain-before-merge` — verification is free,
generation is not.

### Step 4 — If it's wrong: NO BLIND LOOPS
Never reply "doesn't work / fix it" — that buys another guess at full price. Gather the
evidence free (exact error, log line), diagnose free (read it yourself / free strong
model), then ONE new prepared prompt: "Fails with <exact error> at <location>; likely
cause <diagnosis>; fix only <scope>."

### Step 5 — Bookkeeping
Note rough credits per generation in the impl-log's generation table. A month of data
shows which task types deserve the budget.

## Decision gates

- No paid generation without a filled template — the urge to "just type into Cascade"
  is the trigger to run this skill, not to skip it.
- Two failed prepared shots on the same problem = stop; the problem is
  under-understood, not under-generated → back to `feature-brief` or `domain-tutor`.
- Credits buy code, never comprehension.

## Output format

The deliverable is a ready-to-paste prompt (from a template, fully filled) plus the
one-line spend/no-spend verdict for Step 1. No persistent artifact beyond the
impl-log's credit notes.

## Gotchas

- A weak model + a filled template beats a strong model + a vague sentence.
- Weak models drift into unrequested changes — always constrain scope explicitly.
- Long confused chats waste money — restate cleanly in a fresh chat instead of arguing.
- Don't paste giant raw context; paste the relevant mentor-reference pattern instead.

## Evaluation checklist

- [ ] Step-1 verdict given before any generation?
- [ ] Template fully filled, with a named precedent or pasted reference pattern?
- [ ] Version anchors and scope constraints included?
- [ ] After failure: evidence gathered free and ONE surgical retry prepared (no blind loops)?
- [ ] Credit cost noted in the impl-log?

## References

- `references/weak-model-playbook.md` — getting strong-model results from older models
  + anti-mislead defenses (trust ladder, fluency ≠ correctness, loop trap).

## Assets

- `assets/prompt-templates.md` — the four one-shot templates (feature, bug fix,
  plan-only, explain).
