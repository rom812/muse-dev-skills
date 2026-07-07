---
description: Learn one domain concept (service, flow, term) and save a knowledge note in my own words
---

# /tutor — Domain Tutor

1. Scope to ONE concept (a service, a flow, a term). If my ask is broad, split it and
   pick the piece blocking my current task.
2. Gather: search the wiki MCP for the concept; find the 1-2 implementing classes via
   Bitbucket/repo search; read entry points only (interfaces, public methods, config).
   Optionally add 1-2 Exa MCP searches for the generic public concept (standards,
   vendor-neutral explanations) — but never present a public source as fact about OUR
   product without a "verify in code" tag.
3. Explain in layers, checking I follow between each:
   a. One sentence: what it is and why it exists.
   b. Neighborhood: what feeds it, what consumes it.
   c. ONE concrete end-to-end trace of a real scenario (name actual classes/methods).
   d. Glossary: 3-6 domain terms, one line each.
   e. A mermaid sequence/flow diagram of the trace.
4. Feynman check: ask me to explain it back in 2-3 sentences without looking; correct me.
   Then quiz me with 3 questions (include one "what breaks if X disappears?") — present
   the quiz as suggested-responses multi-choice so answering costs one click.
5. Save `.agent/knowledge/<concept-kebab>.md` with: what it is (MY words — make me
   rephrase, don't paste yours) / where it sits / the trace + diagram / glossary / quiz /
   confidence level (learning | solid | could-teach-it).

Note: knowledge notes stay in this work environment. Never move wiki content or code
into personal accounts/repos.
