---
name: precedent-check
description: 'Before writing any new util, converter, mapper, helper, validator, or service method, search the codebase for one that already exists — by name, by type signature, by call site, and by test. Returns EXISTS / PARTIAL / NONE plus the pattern to imitate. Use before generating any new shared code.'
argument-hint: "<what you are about to write>"
subagent: true
---

# Precedent Check

The cheapest skill in the set, guarding the most expensive kind of mistake: **shipping a
second implementation of something the team already has.**

That mistake reads badly out of proportion to its size. A bug says you are learning; a
duplicate `StatusLabelMapper` next to the existing `EntityStatusConverter` says you did
not look. It is also the single easiest failure to eliminate, because the answer is
always already in the repo.

> **Runs as a subagent** (`subagent: true`): read-only, its own context window, on the
> cheap default subagent model. A full sweep costs near-nothing and never pollutes the
> main conversation. The field is Devin-only and marked experimental — if skills ever
> stop loading, remove it first; the skill then runs inline and still works.

## When this triggers

- About to write any new converter, mapper, formatter, validator, util, helper,
  factory, resolver, or service method that feels generic.
- A `task-planner` step is about to generate shared code.
- Reviewing a diff that adds a new class whose name ends in a generic suffix.
- The user invokes `/precedent`.

## When this does not trigger

- Understanding what a subsystem *is* → `domain-tutor`.
- Mapping where things live across repos → `code-cartographer`.
- Tracing what happens at runtime → `flow-tracer`.
- Genuinely feature-specific code with a domain-specific name — no precedent to find.

## Required inputs

One line: what you are about to write, phrased as input → output.
("enum `EntityStatus` → display string for the topology table")
If not supplied, infer it from the current diff or plan step rather than asking.

## Workflow — a four-angle sweep

Run all four. Each angle is blind to what the others find; one angle alone is how the
duplicate gets through.

### 1. By name
The concept noun, plus every generic suffix the codebase uses:
`Converter · Mapper · Formatter · Translator · Serializer · Adapter · Factory · Builder ·
Util · Utils · Helper · Provider · Resolver · Handler · Validator · Support`
Search case-insensitively and on the *noun*, not the full class name you had in mind.

### 2. By type signature
Ignore names entirely — search for the shape. The input type, the return type, and
their combination. A method doing your exact job may be a private method on an
unrelated class, and only the signature finds it.

### 3. By call site
Find somewhere the same thing is already displayed, persisted, or emitted, then read
how it does it. In a UI task: another view rendering the same field. In a service task:
another consumer of the same event. This angle finds the *pattern* even when it finds
no reusable unit.

### 4. By test
Search test names and assertions for the behaviour, not the type. Tests describe intent
in plain language, so they surface implementations whose names you would never guess.

### Then check the candidate is actually usable
- Is it deprecated, or does a newer one supersede it?
- Is it in a module this code can depend on, or would using it invert the layering?
- Is it public API or someone's private helper?

## Output format

A verdict, then evidence. Under 200 words. Never dump file contents.

- **EXISTS** — `path:line`, its exact signature, and the one-line call to make.
  Stop; do not generate.
- **PARTIAL** — the closest thing, plus what it lacks and whether extending it is
  cleaner than adding beside it. Recommend one.
- **NONE** — say so plainly, then name the closest analogous implementation in the
  codebase as the pattern to imitate (naming, layering, error handling, test shape).
  A NONE verdict without a pattern to imitate is an incomplete answer.

Always state which of the four angles were run. A sweep that skipped an angle must
say so rather than implying full coverage.

## Decision gates

- No new generic-suffix class is generated before this returns a verdict.
- An **EXISTS** verdict blocks generation. If it must be written anyway, the reason
  goes in the `impl-log` decision table — that is exactly the "why did you implement it
  like that?" question you will be asked.
- Uncertain candidates resolve toward reuse: propose the existing one and let the
  reviewer say no. Being told "actually write a new one" costs nothing; the reverse
  costs a PR round and a ledger entry.

## Gotchas

- Searching for the class name you already decided on finds nothing and proves nothing.
  Search the *noun* and the *signature*.
- The existing utility is often in a module you have not opened. Sweep the whole repo,
  and check sibling repos via `code-cartographer`'s SYSTEM-MAP when the type is shared.
- Do not stop at the first plausible hit — angle 1 finds the obvious duplicate, angle 3
  finds the one with the better pattern.
- A hit that is deprecated is not a hit. Say so, and name the replacement.

## Evaluation checklist

- [ ] All four angles run, and any skipped angle explicitly declared?
- [ ] Searched by noun and by signature, not by the intended class name?
- [ ] Candidate checked for deprecation, module visibility, and layering?
- [ ] Verdict is one of EXISTS / PARTIAL / NONE, with `path:line` evidence?
- [ ] On NONE, a concrete pattern to imitate was named?
- [ ] Under 200 words, no file dumps?
