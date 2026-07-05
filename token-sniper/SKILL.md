---
name: token-sniper
description: 'Discipline for spending a tiny monthly AI-credit budget surgically: decide if a task deserves credits, prepare a one-shot prompt offline, and never enter blind fix-loops. Use before any paid AI generation at work or when drafting prompts for a weaker model.'
---

# Token Sniper

You get ~1000 credits a month at work, on older models. Every credit spent on a lazy
prompt or a "still broken, fix it" loop is a credit not available when it matters.
This skill turns each generation into a **prepared, single, well-aimed shot**.

## When this triggers

- The user is about to use paid AI at work and wants the prompt prepared.
- The user is deciding whether a task is even worth credits.
- A previous generation failed and the user is tempted to reply "doesn't work, fix".
- The user invokes `/token-sniper`.

## Step 1 — Should this cost credits at all?

| Task | Spend credits? |
|---|---|
| Find where something is / how it's called | ❌ grep / IDE navigation / Bitbucket search |
| What does this domain term mean | ❌ wiki MCP / knowledge notes / ask at home |
| How does a Java/Spring API work | ❌ docs / Claude at home (abstractly) |
| Boilerplate identical to an existing precedent | ⚠ copy the precedent by hand first; AI only if genuinely faster |
| New logic in existing patterns | ✅ one prepared prompt |
| Gnarly multi-file change | ✅ but plan at home first, then one prepared prompt per step |

Rule of thumb: **credits are for writing code, never for understanding.** Understanding
comes from grep, docs, wiki, knowledge notes, and free Claude at home.

## Step 2 — Prepare the shot (offline, costs nothing)

Fill the one-shot template (`assets/prompt-templates.md`) BEFORE opening Cascade:

1. **Goal** — one sentence, from the brief's acceptance criteria.
2. **Context** — name the exact files to read, and *the precedent*: "follow the pattern
   of `ExistingSimilarTool.java`". Weak models with a concrete example to imitate perform
   like strong models; weak models told to invent perform like dice.
3. **Constraints** — version, conventions, what NOT to touch, error-handling expectations.
4. **Expected output** — which files created/modified, and "explain any non-obvious line".
5. **Verification** — "after generating, list what I should test to prove this works."

A weak model + this template beats a strong model + a vague sentence.

> Working with the older work models specifically — and defending against being misled
> by them — is covered in `references/weak-model-playbook.md`. Core ideas: weak models
> imitate better than they reason (patterns > instructions), decompose ruthlessly,
> fresh chat when confused, and verification rules for output you can't yet judge.

## Step 3 — Fire once, then verify

Run the prompt. Then go straight to `/explain-before-merge` — verification is free,
generation is not.

## Step 4 — If it's wrong: NO BLIND LOOPS

Never reply "doesn't work" / "fix it" — that buys another guess at full price. Instead:

1. Gather the *evidence* for free: exact error, log line, wrong behavior observed.
2. Diagnose for free where possible: read the failing code yourself, or take the error
   to Claude at home (abstracted).
3. If AI is still needed, send ONE new prepared prompt: "This fails with <exact error>
   at <location>. The cause is likely <your diagnosis>. Fix only <scope>."

Two failed prepared shots on the same problem = stop. The problem is under-understood,
not under-generated → back to `/feature-brief` or `/domain-tutor`.

## Budget bookkeeping

Note credits spent per task in the impl-log's generation table (rough count is fine).
A month of data shows exactly which task types deserve the budget — and it proves the
fix-loop cost drop over time.
