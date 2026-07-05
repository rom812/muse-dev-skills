---
description: Turn a new task into a one-page feature brief with smart questions — BEFORE any code
---

# /brief — Feature Brief (understand before coding)

Hard rule: no implementation until this brief is filled.

1. Ask me to paste the raw task exactly as given (Jira/chat). Record it verbatim.
2. Make me restate it in my own words: current behavior, desired behavior, trigger
   (user action / topology event / job / chat message). If I can't answer one, mark it
   `UNKNOWN` — it becomes a question in step 4.
3. Map the blast radius using the repo (and Bitbucket/wiki MCP if helpful):
   - services/classes touched
   - the nearest existing precedent feature to imitate
   - what could break
4. Draft 2-4 clarifying questions for my boss. Rules: never "how do I do this"; always
   options + my leaning ("I see A or B, I lean A because…"); include one scope-boundary
   question and one acceptance-confirmation question ("when <trigger>, system should
   <observable result> — correct?"). Batch into ONE copy-pasteable message.
5. Write `.agent/briefs/NNN-<kebab-name>.md` (NNN = next number) with sections:
   Raw task / In my own words / Blast radius / Questions (+ answers) / Acceptance
   criteria (checkboxes) / Plan (steps + test plan) / Assumptions. Status `[DRAFT]`.
6. Run the Understanding Check with me — all must be YES before coding:
   - I can explain the feature without reading the ticket
   - I know which files I'll touch
   - I know how I'll prove it works
   - Open questions are sent or consciously assumed (written down)
   Any NO → stop; route to /tutor (knowledge gap) or back to questions (requirements gap).
