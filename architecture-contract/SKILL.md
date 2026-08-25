---
name: architecture-contract
description: 'Make the intended architecture explicit before code is placed: extract the layers, dependency directions and canonical flows into one short reviewable contract, check every plan step or diff against it (FITS / VIOLATES / UNCOVERED), and promote repeated clauses into ArchUnit tests so the build enforces them. Use before generating code into an unfamiliar codebase, and whenever "where does this go?" has no confident answer.'
argument-hint: "map | check <plan step or diff> | enforce [clause]"
---

# Architecture Contract

`precedent-check` stops you shipping a second copy of something that exists. This skill
stops the other half: code that is **new, correct, and in the wrong place.**

That failure is worse than a bug for one specific reason — you cannot catch it. A bug
announces itself. Code in the wrong layer compiles, passes its test, and looks finished.
If you are new to the codebase you have no way to grade the AI's placement decision, so
the first person who notices is the architect in review, and what they see is not "junior
made a mistake" but "junior did not understand the design." The whole point of this skill
is to stop being the last line of defence for a decision you are not yet equipped to make.

The move is to stop treating architecture as something you *know* and start treating it as
something the repo *states*. A written contract is reviewable in one pass by the person who
designed it — which is a far cheaper conversation to ask for than a review of every PR you
will ever open.

> **Discovery runs as a read-only subagent** where the harness supports it (`map` mode
> sweeps a lot of files and returns a short table). `check` runs inline — it is small, and
> its verdict has to be visible in the conversation where the code is about to be written.

## When this triggers

- Before the first `[GEN]` step of any `task-planner` plan that adds a new class or method.
- Any time the honest answer to "which file does this go in?" is a guess.
- A brief names a flow ("this goes through the ingest pipeline") that you cannot draw.
- Reviewing an AI diff that created a new file, or added a dependency between packages.
- A correction in `corrections-ledger` was about placement, not correctness.
- The user invokes `/arch`.

## When this does not trigger

- What a subsystem *is* or why it exists → `domain-tutor`.
- Where a thing lives across repos → `code-cartographer`.
- What happens step by step at runtime → `flow-tracer` (this skill *calls* it).
- Whether a utility already exists → `precedent-check`.
- Editing inside one existing file, with no new dependency → no contract question exists.

## Required inputs

- **`map`** — nothing. Infer the repo root from the workspace.
- **`check`** — the plan step, file list, or diff under judgement. If not supplied, use the
  current diff rather than asking.
- **`enforce`** — the clause to mechanise, or nothing to promote every CONFIRMED clause.

## The artifact

One file, `.agent/ARCHITECTURE.md` (work repo, local-only) or `knowledge/architecture.md`
(home). It is the contract. It must stay **under two pages** — a contract nobody reads
enforces nothing, and the whole strategy depends on your architect actually reading it once.

```markdown
# Architecture Contract — <repo>
Last confirmed: <date> by <who>   |   Clauses: 9 confirmed, 3 derived

## Layers
| Layer | Package | Holds | Must NOT hold | Reached from |
|-------|---------|-------|---------------|--------------|
| UI | `..ui..` | Vaadin views, presenters | business rules, repo calls | — |
| Service | `..service..` | orchestration, business rules | HTTP/UI types | UI |
| Persistence | `..repository..` | entities, queries | business rules | Service |

## Canonical flows
### chat-message-ingest  ✅ confirmed
`ChatView` → `ChatService.handle()` → `AdvisorChain` → `ToolCallback` → `MessageRepository`
New tool-calling behaviour attaches at the advisor, NOT in the view and NOT in the service.

## Clauses
- ✅ **C1** Repositories are reached only from services. *(confirmed 2026-08-12, PR #204)*
- ⚠ **C7** DTOs do not leave the web layer. *(derived from package structure — unconfirmed)*

## Open questions for the architect
- Q1: Should retry logic live in the advisor or the service? C7 does not say.
```

Two markers, and they carry the whole weight of the skill: **✅ confirmed** means a human
who owns the design said so, or an ArchUnit test enforces it. **⚠ derived** means you
inferred it from the code and it may be describing an accident. Never present a derived
clause as the architecture — deriving rules from the same code the AI is about to modify is
exactly how a drift becomes a standard.

## Workflow — mode: `map`

Five angles. Each is blind to what the others see; the package tree alone will confidently
tell you the wrong thing.

### 1. By package structure
Read the tree, not the files. Top-level packages under the root are the intended layers,
and their names are the architect's own vocabulary — reuse those words in the contract so
your questions sound like the codebase.

### 2. By dependency direction
Which package imports which. Draw the arrows and look for the ones pointing backwards — a
repository importing a service, a domain class importing a web DTO. A backwards arrow is
either a violation or a clause you have not understood yet, and telling those apart is the
single most valuable question you can bring to your architect.

### 3. By the canonical flow
Pick the **most established** feature — oldest, most-referenced, most-tested — and trace it
end to end via `flow-tracer`. The path a mature feature takes is the contract for features
like it. This is the angle that answers "the flow my boss built that things go through."

### 4. By convention markers
Annotations, base classes, naming suffixes, `package-info.java`, module boundaries, and any
existing `archunit`/Modulith tests. **Existing architecture tests outrank everything else in
this list** — they are clauses someone already bothered to make executable, so they are
confirmed by definition.

### 5. By past corrections
Read `corrections-ledger` for placement corrections. Those are contract clauses already paid
for in embarrassment; they belong in the file so the price is only paid once.

### Then close the loop
Write the file. List what you could **not** determine as `Open questions`, each phrased with
your best guess attached ("I read it as X because Y — is that right?"). Per `stuck-protocol`,
a question with a guess reads as ownership; a bare question reads as dependence. Then ask
your architect to correct the file, not to explain the architecture. Reviewing nine wrong
lines takes ten minutes; explaining a system from scratch takes an hour, which is why the
second request quietly never gets granted.

## Workflow — mode: `check`

Against the contract, for each new or moved file in the plan step or diff:

1. Which layer does the target file sit in?
2. Which layer does the *behaviour* belong to, per the Layers table?
3. Does the change add a dependency arrow? Is that direction allowed?
4. Does it touch a named canonical flow? Does it attach at the stated point?

Then one verdict per change:

- **FITS** — name the clause it satisfies. One line, no ceremony.
- **VIOLATES** — name the clause, the correct location, and the smallest move that fixes it.
- **UNCOVERED** — the contract does not say. **This is a real verdict, not a failure.**
  Stop, write it into `Open questions`, and either ask or proceed with the assumption
  stated out loud in the `impl-log` decision table.

`UNCOVERED` is the verdict that does the work you cannot do yourself. It converts "I did not
know the AI was wrong" into "the contract does not cover this yet" — a known unknown you can
hand to someone, instead of a silent guess that surfaces in review.

## Workflow — mode: `enforce`

Same escalation as `corrections-ledger`: a clause that has to be enforced twice stops being
a note and becomes a test. In Java, that is [ArchUnit](https://www.archunit.org) — the build
becomes the last line of defence instead of you.

```java
// src/test/java/.../ArchitectureTest.java
@AnalyzeClasses(packages = "com.example.muse", importOptions = ImportOption.DoNotIncludeTests.class)
class ArchitectureTest {

    @ArchTest  // C1
    static final ArchRule layering = freeze(layeredArchitecture()
            .consideringAllDependencies()
            .layer("UI").definedBy("..ui..")
            .layer("Service").definedBy("..service..")
            .layer("Persistence").definedBy("..repository..")
            .whereLayer("Persistence").mayOnlyBeAccessedByLayers("Service")
            .because("repositories are reached only from services — contract C1"));
}
```

Two details make this usable on a codebase you did not write:

- **`FreezingArchRule.freeze(...)`** records today's violations to a committed store
  (`archunit_store/`, enabled once with `freeze.store.default.allowStoreCreation=true` in
  `src/test/resources/archunit.properties`). Only **new** violations fail the build, and
  fixed ones shrink the store automatically. You never have to clean up inherited debt to
  start protecting against your own — which is the only reason this is proposable by a
  newcomer at all.
- **`.because("... contract C<n>")`** ties every failure back to the clause. The failure
  message teaches the rule, so the test file becomes the readable architecture doc.

Only mechanise **✅ confirmed** clauses. Freezing a derived clause promotes your guess to law
and makes you the author of a rule nobody agreed to.

## Output format

Under 250 words. A verdict table, then next actions. Never dump the contract back — it is a
file, and the point of a file is that it does not have to be repeated.

| Change | Verdict | Clause | Action |
|--------|---------|--------|--------|
| `RetryAdvisor.java` → `..service..` | VIOLATES | C4 | move to `..advisor..` |
| `TokenBudgetTracker.java` | UNCOVERED | — | Q3 → ask, or state assumption in impl-log |

State how many clauses are confirmed versus derived every time. A check run against a
mostly-derived contract is weak evidence and must say so rather than sounding authoritative.

## Decision gates

- ⛔ No new **file** is generated before `check` returns a verdict for it. New files are
  where placement mistakes live; edits inside an existing file are rarely the problem.
- ⛔ A **VIOLATES** verdict blocks generation. Overriding it is allowed, but the reason goes
  in the `impl-log` decision table — that is verbatim the "why did you put it there?"
  question you will be asked in review.
- An **UNCOVERED** verdict never silently becomes a guess. It goes to `Open questions` in the
  same session, or the assumption is written down. Both are acceptable; forgetting is not.
- The contract is re-confirmed after any architecture conversation, and its
  `Last confirmed` date updated. A contract older than the last refactor is fiction.

## Gotchas

- **Derived is not confirmed.** The most dangerous output of this skill is a plausible
  contract nobody has checked, because it launders your assumptions into something that
  looks authoritative. Keep the ⚠ markers visible until a human clears them.
- **The package tree lies about intent.** It shows where code ended up, including every past
  violation. Angle 3 (the canonical flow) is what shows where code was *meant* to go, which
  is why it is the angle you must not skip when you are short on time.
- **Do not map the whole system.** One area per session, like `code-cartographer`. A
  two-page contract for the part you are touching beats a complete one you never finished.
- **Right layer, wrong service is still wrong** and this skill only catches it through the
  canonical-flow angle. If the flow is not mapped, `check` cannot see that failure — say so
  in the output rather than implying full coverage.
- **ArchUnit only sees structure.** It enforces "no repository import in the UI layer"
  perfectly and "this belongs in the advisor, not the service" not at all. The contract
  covers the second kind; do not assume a green build means a fitting design.
- **Do not propose ArchUnit unfrozen** on an inherited codebase. Hundreds of red tests on
  your first architecture PR reads as a newcomer criticising the team's work.

## Evaluation checklist

- [ ] All five map angles run, and any skipped angle explicitly declared?
- [ ] Every clause marked ✅ confirmed or ⚠ derived, with confirmations sourced?
- [ ] At least one canonical flow traced end to end, not just layers listed?
- [ ] Contract under two pages, with `Open questions` phrased as best-guess questions?
- [ ] Each change given exactly one of FITS / VIOLATES / UNCOVERED, with a clause reference?
- [ ] Confirmed-vs-derived ratio stated in the check output?
- [ ] `enforce` used only on confirmed clauses, frozen, with `.because()` citing the clause?
