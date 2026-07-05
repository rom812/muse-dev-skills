---
name: domain-tutor
description: 'Learn one unfamiliar domain concept (a service, subsystem, protocol, or flow) and produce a permanent knowledge note in the user''s own words, with a diagram and self-quiz. Use when the user says they don''t understand a service, concept, or how something works in their product domain.'
---

# Domain Tutor

Builds a personal domain wiki, one concept at a time. Designed for a developer who is new
to a large telecom/network-management product (Muse) where the hard part isn't the code —
it's the *domain* (topology, network elements, services, events, jobs).

## When this triggers

- The user names something they don't understand: "what is the topology service",
  "how does the trigger engine work", "what's a link in Muse".
- A `/feature-brief` Understanding Check failed on a knowledge gap.
- The user invokes `/domain-tutor <concept>`.

## Protocol

### Step 1 — Scope to ONE concept

One note = one concept. "Understand Muse" is not a concept; "how the chatbot's
topology-read tool gets its data" is. If the ask is broad, split it and pick the piece
that blocks the current task.

### Step 2 — Gather (environment-dependent)

- **At work (Windsurf, with Bitbucket + wiki MCPs):** search the wiki for the concept,
  find the 1-2 classes that implement it, read entry points only (interfaces, public
  methods, config) — not every line.
- **At home (Claude Code, no work code):** work from what the user remembers + public
  knowledge of the domain (telecom/network management concepts, Spring patterns). Mark
  anything unverified with `⚠ verify at work`.

### Step 3 — Explain in layers

Deliver the explanation in this order, checking understanding between layers:

1. **One sentence:** what it is and why it exists.
2. **The neighborhood:** what feeds it, what consumes it, where it sits in the product.
3. **One concrete walkthrough:** trace a single real scenario end-to-end
   (e.g., "user deletes a link → event fires → trigger engine matches job → chatbot tool
   runs → report generated"). Concrete traces beat abstract descriptions every time.
4. **Glossary:** the 3-6 domain terms that appeared, each defined in one line.
5. **Mermaid diagram** of the flow (sequence or flowchart, whichever fits).

### Step 4 — Feynman check

Ask the user to explain the concept back in 2-3 sentences *without looking*. Correct
gently, then ask the 3 quiz questions from the note. A concept isn't "learned" until
the user can answer them cold.

### Step 5 — Save the note

Write `.agent/knowledge/<concept-kebab>.md` from `assets/knowledge-note-template.md`.
The note MUST be in the user's own words (edit together if needed) — copy-pasted
explanations don't build memory, and copy-pasted proprietary content must never leave
the work environment anyway.

## Rules

- **Own words only** in saved notes. The AI drafts, the user rewrites key sentences.
- **One concrete trace per note.** No note ships with only abstract description.
- **Link notes** to each other (`[[other-note]]`) and to the briefs that needed them.
- **Confidentiality:** notes written at work stay in the work environment. Never paste
  wiki content or code into personal AI accounts; describe abstractly instead.

## Output format

Persistent artifact: the knowledge note. In chat: the layered explanation, the quiz,
and the note's location.

## The compounding effect

Ten notes in, the user has a personal onboarding guide nobody else has — and re-reading
`.agent/knowledge/` before a planning meeting is how a junior starts answering domain
questions in front of the team.
