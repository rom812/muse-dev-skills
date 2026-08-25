---
name: domain-tutor
description: 'Learn one unfamiliar domain concept (a service, subsystem, protocol, or domain term) and produce a permanent knowledge note in the user''s own words, with a diagram and self-quiz. Use when the user asks what a service, subsystem, or domain term IS or WHY it exists, or says they don''t understand one, in their product domain. Not for step-by-step runtime tracing — that is flow-tracer.'
---

# Domain Tutor

Builds a personal domain wiki, one concept at a time. Designed for a developer who is
new to a large telecom/network-management product (Muse) where the hard part isn't the
code — it's the *domain* (topology, network elements, services, events, jobs).

## When this triggers

- The user names something they don't understand: "what is the topology service",
  "how does the trigger engine work", "what's a link in Muse".
- A `feature-brief` Understanding Check failed on a knowledge gap.
- The user invokes `/domain-tutor <concept>`.

## When this does not trigger

- Requirements/scope confusion about a specific task → that's `feature-brief` Step 5.
- Framework API questions with a pattern answer → `spring-ai-mentor` / `vaadin-mentor`.
- Being stuck on an error → `stuck-protocol`.
- "What actually happens when X" — step-by-step runtime behavior → `flow-tracer`
  (that produces a trace note; a tutor session may cite an existing trace, not create one).
- Where code lives / repo and module structure → `code-cartographer`.

## Required inputs

- ONE named concept (split broad asks; pick the piece blocking the current task).
- Why the user needs it now (which task/brief) — shapes the concrete trace.
- Environment: work (wiki/repo available) or home (public knowledge only).

## Interactive questions rule

Batch all questions to the user into ONE message using the interactive question UI
(`AskUserQuestion` in Claude Code, suggested-responses multi-choice in Cascade) —
including the scoping choice, the Feynman check, and the quiz. Never end a turn on an
open free-text question when options can be offered.

## Workflow

### Step 1 — Scope to ONE concept

One note = one concept. "Understand Muse" is not a concept; "how the chatbot's
topology-read tool gets its data" is. Offer the split as multi-choice options.

### Step 2 — Gather (environment-dependent)

- **At work:** search the wiki for the concept; find the 1-2 implementing classes via
  Bitbucket/repo search; read entry points only (interfaces, public methods, config).
  If the **Exa MCP** is available, optionally pull 1-2 public sources on the general
  concept (telecom/networking standards, vendor-neutral explanations) to complement
  the internal view.
- **At home:** work from what the user remembers + public knowledge; use
  Tavily/WebSearch/Exa for 1-2 authoritative public sources. Mark anything unverified
  with `⚠ verify at work`.

### Step 3 — Explain in layers

1. **One sentence:** what it is and why it exists.
2. **The neighborhood:** what feeds it, what consumes it, where it sits.
3. **One concrete walkthrough:** trace a single real scenario end-to-end. Concrete
   traces beat abstract descriptions every time.
4. **Glossary:** the 3-6 domain terms that appeared, one line each.
5. **Mermaid diagram** of the flow (sequence or flowchart).

### Step 4 — Feynman check

Ask the user to explain the concept back in 2-3 sentences *without looking* (free text
is fine here — it's the one answer that can't be multiple choice). Correct gently, then
run the 3 quiz questions as interactive multi-choice. A concept isn't learned until
they answer cold.

### Step 5 — Save the note

Write `.agent/knowledge/<concept-kebab>.md` from `assets/knowledge-note-template.md`.
The note MUST be in the user's own words — the AI drafts, the user rewrites key
sentences.

## Decision gates

- Don't proceed past Step 1 with more than one concept in scope.
- Don't save a note whose "What it is" line the user hasn't rephrased themselves.
- Don't ship a note with only abstract description — one concrete trace is mandatory.
- Confidentiality: notes written at work stay at work; never paste wiki content or
  code into personal AI accounts — describe abstractly instead.

## Output format

Persistent artifact: the knowledge note at `.agent/knowledge/<concept>.md`. In chat:
the layered explanation, the quiz, and the note's location.

## Gotchas

- The 2-hour rabbit hole: one concept, ~30 minutes, save, back to work. Mark gaps
  `⚠ verify` and move on.
- Copy-pasted explanations don't build memory — the rephrasing IS the learning.
- Link notes to each other (`[[other-note]]`) and to the briefs that needed them.
- Web sources describe the *generic* concept; the product may diverge — never present
  a public source as fact about the product without a `⚠ verify at work` tag.

## Evaluation checklist

- [ ] Exactly one concept scoped, chosen via interactive options?
- [ ] Explanation delivered in the 5 layers, with a concrete end-to-end trace?
- [ ] Feynman check + 3-question quiz run (quiz via interactive UI)?
- [ ] Note saved with the user's own words in the key sentences?
- [ ] Unverified claims tagged `⚠ verify at work`?

## Assets

- `assets/knowledge-note-template.md` — the note structure; fill it for Step 5.
