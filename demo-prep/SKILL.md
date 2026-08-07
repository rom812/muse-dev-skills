---
name: demo-prep
description: 'Prepare for a demo, review, or walkthrough with a boss who specifies requirements iteratively: rehearse the path, state scope up front, predict the "can you also…" asks with prepared answers, disclose known gaps first, and capture every new ask as dated scope. Use before any demo, HLD review, or sprint review.'
argument-hint: "[task or brief number]"
---

# Demo Prep

Built for one specific and very common situation: **a boss who does not specify
requirements up front, and instead discovers them at the demo.**

The instinct is to treat that as unfairness. It is more useful to treat it as a
predictable input. If new requirements always arrive at the demo, then the demo is a
requirements meeting, and you can prepare for a requirements meeting. Done well it
inverts the dynamic — instead of being surprised, you are the person who already
considered it.

This skill produces three things: a rehearsed demo, a scope statement said *before*
anyone can drift, and a written record of what got added and when.

## When this triggers

- A demo, sprint review, HLD review, or walkthrough is scheduled or imminent.
- A task is about to be shown to the boss for the first time.
- The user invokes `/demo`.

## When this does not trigger

- Preparing a written PR for async review → `explain-before-merge` (its output feeds
  this skill, but the gates live there).
- The task is not built yet → `feature-brief` / `task-planner`.
- Composing a status update rather than showing working software → `standup-reporter`.

## Required inputs

- Which task/brief, and the audience (boss / skip-level / team).
- How long you have, and whether it is live or recorded.

Pull everything else from `.agent/briefs/NNN-*.md` (acceptance criteria, out-of-scope),
`.agent/design-logs/<feature>/NNN-*.md` (what was built, what is shaky — the feature
INDEX.md Snapshot is the fastest read), and
`.agent/knowledge/corrections.md` — do not ask for what is already written down.

## Workflow

### 1. Rehearse the actual path (non-negotiable)
Run the demo end to end, for real, on the machine you will present from. Note the exact
click path and any step that needs a wait, a restart, or a specific fixture. An
unprepared demo undoes weeks of good work in four minutes; a rehearsed one is the
cheapest credibility you can buy.

Record: the path, the setup preconditions, and the one step most likely to fail live.

### 2. Write the scope statement — the actual lever
One sentence delivered *before* the first click:

> "Today covers **X**. **Y** and **Z** are deliberately out of scope for this pass —
> happy to talk about where they'd fit after."

This single move is what converts mid-demo scope creep from a surprise into a scheduled
conversation. It also makes every later "can you also…" land as a *new* request rather
than a gap in your work, which is the difference between looking incomplete and looking
organised.

### 3. Predict the asks
Generate the five most likely "can you also…" requests. Source them from:
- the brief's explicit out-of-scope list (the boss never read it — these come back first),
- adjacent surfaces the demo will visibly touch (the other tab, the other entity type),
- the polish layer: empty states, error states, loading, counts, sorting, permissions,
- what was asked at the last demo of a similar task (from prior demo cards).

### 4. Prepare an answer for each — three buckets only
| Bucket | Answer shape |
|---|---|
| **Already handled** | "That's in — let me show you." Then show it. |
| **Small** | "Half a day. I can have it Thursday." A named size and a named date. |
| **Actually a new task** | "That needs \<the real dependency\>. Want me to write it up as its own brief?" |

Never answer "yes I'll add that" without a bucket. Unsized agreement is how a two-day
task becomes three weeks with no record of why.

### 5. Disclose known gaps first
List the two or three weak spots and say them before anyone finds them. Naming your own
gaps reads as senior judgment; having them found for you reads as inattention. Each gap
gets: what it is, whether it is deliberate, and what it would take.

### 6. Run the ledger check
`corrections-ledger check` against the diff. A repeat of a past correction, surfaced
live in a demo, is the single most expensive moment available — and the most avoidable.

### 7. After the demo — capture (2 minutes, same day)
Every new ask goes into the demo card with a date and a bucket, then:
- **Already handled** → nothing.
- **Small** → an `impl-log` entry on the current task.
- **New task** → a new `feature-brief`, and say so in writing that day.

This is the receipts trail. When a task has run long, "here are the six requirements
added on the 9th, 16th, and 24th" is a fact, not a complaint — and it is the difference
between looking slow and looking like you absorbed a moving target.

## Decision gates

- No demo without step 1 actually executed. "I'm sure it works" is not a rehearsal.
- No demo without the scope statement written down and said first.
- No new ask leaves the room unbucketed and undated.
- A `⚠ REPEAT` from the ledger check blocks the demo until it is fixed or has a
  prepared, honest answer.

## Output format

Persistent artifact: `.agent/briefs/NNN-<task>-demo.md` from
`assets/demo-card-template.md` — one page, readable at a glance while presenting.

In chat: the scope statement, the five predicted asks with their buckets, and the
gap list. Nothing else — you need something you can hold in your head, not a script.

## Gotchas

- Do not demo from a dirty branch or an IDE full of red squiggles. What is on screen
  is being reviewed whether or not it is the subject.
- Resist demoing more than the scope statement claims. Extra surface invites extra asks.
- If the boss no-shows — a real and recurring possibility — record the demo instead,
  send it with the scope statement in the message body, and ask for the same three
  decisions in writing with a default-and-deadline. The prep is not wasted.
- Keep the card honest. A predicted-asks list that was wrong is useful data for the
  next one; quietly rewriting it afterwards is not.

## Evaluation checklist

- [ ] Demo rehearsed end to end on the presenting machine, fragile step identified?
- [ ] Scope statement written, and delivered before the first click?
- [ ] Five asks predicted, each with a bucket and (where relevant) a named date?
- [ ] Known gaps disclosed proactively rather than discovered?
- [ ] `corrections-ledger check` run against the diff?
- [ ] Post-demo: every new ask captured with a date and routed to log or brief?
- [ ] Demo card saved next to the brief?

## Assets

- `assets/demo-card-template.md` — the one-page card: scope statement, click path,
  predicted asks, gaps, and the post-demo capture table.
