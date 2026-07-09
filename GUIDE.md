# The Usage Guide — how to actually run each skill

[WORKFLOW.md](WORKFLOW.md) shows the loop; this guide shows the *craft* — when to fire
each skill, exactly what to type, what good output looks like, and the mistakes that
kill each one. Examples use the real stack: Muse chatbot, Spring Boot + Spring AI,
Vaadin UI, topology tools, STT/TTS, job triggers.

**Legend:** 🏠 = Claude Code at home (free, strong) · 🏢 = Windsurf at work (credits, weaker models)

---

## 1. /feature-brief — fire the moment a task lands 🏢 (draft) + 🏠 (thinking)

**Fire when:** my boss assigns anything bigger than a one-line fix. Before ANY code. Before
you even estimate — the brief is what makes your estimate real.

**How to invoke well:** paste the task *verbatim*, don't summarize it. The ambiguities in
my boss's exact words are the raw material for your questions.

> `/brief` → *"my boss wrote in chat: 'we want the bot to also handle the case when a link
> goes down, same like the delete thing you did'"*

**What good looks like:** the skill should force out the hidden questions. In that
example: is "goes down" a status-change event or a deletion event? Same report format?
Should it fire per-link or debounce a flapping link? A brief that produces zero questions
means you ran it too shallow.

**The craft:**
- Do the restating step *without looking at the ticket* — that's the whole point. If you
  can't, that's a real signal, not an inconvenience.
- Step 3 (blast radius): always name the **precedent file** — for the example above,
  your existing link-deleted trigger. "Same as X but for Y" tasks are gifts: the brief
  almost writes itself, and the precedent becomes the AI prompt later.
- Send the questions message to my boss *the same day* the task lands. Early questions =
  thorough; late questions = stuck.
- **Don't** let it take more than ~30 minutes. A brief is a thinking tool, not a document
  my boss will ever grade.

**Common mistake:** running /brief but starting to code while "waiting for answers".
If you must move, code only the part no answer can change (test scaffolding, the
precedent copy), and write your assumption in section 7.

---

## 2. /domain-tutor — fire on the gap, not on curiosity 🏠 (concepts) + 🏢 (code-specific)

**Fire when:** a brief's Understanding Check fails on a *knowledge* gap ("I don't actually
know what a topology link IS in Muse"), or the parking lot has collected the same term
three times. Not for idle curiosity mid-task — park it instead.

**How to invoke well:** name ONE concept and *why you need it*:

> 🏠 `/domain-tutor` → *"network topology links and what 'link down' vs 'link deleted'
> means in network management systems — I need it to handle a new trigger type"*
> (abstract telecom knowledge — free, no work code involved)

> 🏢 `/tutor` → *"how OUR trigger engine matches events to jobs — walk me from the
> topology event to my report tool being called"* (needs the repo + wiki MCP)

**What good looks like:** you can answer the 3 quiz questions cold the next morning. If
you can't, re-read *your* note, not the AI's explanation.

**The craft:**
- The concrete trace (step 3c) is the part that sticks. Demand actual class names at
  work; demand a realistic scenario at home.
- Rewrite the "What it is" line yourself, always. The act of rephrasing IS the learning.
- Before any planning meeting, skim your 3 newest notes — that's how you start answering
  domain questions in front of the team.
- Split home/work correctly: telecom/networking/Spring concepts 🏠 free; "how does OUR
  code do it" 🏢 (wiki MCP + repo search cost little; avoid paid generations for this).

**Common mistake:** the 2-hour rabbit hole. One concept, ~30 minutes, save, back to work.
The note doesn't need to be complete — mark gaps `⚠ verify` and move on.

---

## 3. /impl-log — the 2-minute habit that carries everything else 🏢

**Fire when:** three moments — task starts (create), AI generates (row), something
breaks or ships (row / close).

**The craft:**
- Fill "Verified by" **immediately** after each generation, while you still remember
  what you actually checked. This field is the anti-"I don't know what the AI did".
- The decision table is your review armor — one row per weird-looking choice, filled
  during /verify. Before walking into any review with my boss, read your own decision
  table once. That's the entire preparation.
- Fix-cycle rows: the "wrong assumption" column is the only one that matters. After a
  month, `grep -h "assumption" .agent/design-logs/*` — the repeats are your personal checklist.
- Friday: the logs feed /standup weekly automatically. Zero extra work.

**Common mistake:** writing essays. If a log entry takes >2 minutes you'll quit the
habit by Thursday. Telegraphic style; nobody reads this but you.

---

## 4. /explain-before-merge (/verify) — the gate that changes my boss's opinion 🏢

**Fire when:** the diff is done and you're tempted to just push. That temptation is the
trigger. Also whenever the impl-log has a `⚠ magic` row.

**How to invoke well:** run it on the *final* diff, not per-file as you go — the runtime
trace (gate 2) only makes sense on the whole change.

**The craft, gate by gate:**
- **Gate 1 (explain every hunk):** do it out loud, actually. Mumbling counts. Reading
  silently doesn't — your eyes skip what your mouth can't.
- **Gate 2 (trace):** for chatbot changes the trace is nearly always: *user message or
  topology event → tool selection → tool execution → response into the Vaadin chat
  panel*. Walk it naming real methods. Where the trace crosses async boundaries, slow
  down — that's where Muse bugs live.
- **Gate 3 (edge cases):** for THIS app, three checks pay for the whole gate every time:
  1. background thread touching UI without `ui.access()` (+ `@Push` present?)
  2. conversation/user state in a singleton bean field
  3. LLM/tool call without a timeout
- **Gate 5 (review defense):** fill the decision table, rehearse the 3 weirdest lines
  aloud. If my boss asks something you didn't prep: *"I followed the pattern from X — let
  me double-check that choice and get back to you today."* Then actually do it.
- The PR description output is not optional decoration — a filled "How I tested" section
  is the single strongest reputation-builder available to you.

**Common mistake:** running it as a formality after deciding to push. The gate exists to
sometimes STOP you. If it never stops you, you're not running it honestly.

---

## 5. /spring-ai-mentor + /vaadin-mentor — the anti-hallucination references 🏠 + 🏢

**Fire when:** touching Spring AI (tools, ChatClient, memory, streaming) or Vaadin UI
(chat panel, push, audio/avatar). Also BEFORE prompting work AI on these topics.

**The craft:**
- Their best use is **feeding token-sniper prompts**: copy the relevant pattern from the
  reference into your prepared prompt as the example to imitate. Weak work models stop
  hallucinating `FunctionCallback`-era Spring AI or thread-illegal Vaadin the moment you
  show them the correct pattern.
- Debugging shortcut — go straight to the pitfall tables:
  - bot ignores a tool → `@Tool` description (spring-ai §7)
  - answer appears only after clicking → missing `@Push` (vaadin §7)
  - users see each other's chats → scope bug (vaadin §4 + spring-ai §3, check both)
  - UI freezes during answer → blocking call on UI thread (vaadin §2)
- At home, use them as your curriculum: one section per evening with `/domain-tutor`
  turns them into your own knowledge notes.

**Common mistake:** trusting the reference over the codebase. The repo's precedent wins;
the reference tells you what questions to ask of it.

---

## 6. /token-sniper — run it BEFORE opening Cascade, every time 🏠 (prep) → 🏢 (fire)

**Fire when:** you're about to spend work credits. The trigger is the *urge to type into
Cascade*, not any particular task.

**The craft:**
- Prepare the prompt in a scratch file at home or offline using template A/B/C/D. A
  prepared prompt names: the goal (from the brief), the files to read, **the precedent
  to imitate**, the constraints, the output format. That last 10% of specificity is
  worth more than a model upgrade.
- Spring AI/Vaadin tasks: paste the relevant mentor-reference pattern INTO the prompt.
- Template C (plan-only) is criminally underused: for anything multi-file, spend one
  cheap plan-only shot first, sanity-check it against your brief, THEN generate. Two
  small shots beat one confused big one.
- The moment you notice a retry loop starting ("still broken, fix") — hands off the
  keyboard. Evidence first (exact error, log line), diagnosis free (read it yourself /
  🏠 Claude), then ONE surgical template-B shot.
- Log rough credit cost per generation in the impl-log. Month-end, you'll know exactly
  which task types deserve the budget.

**Common mistake:** using credits to *understand* ("what does this class do?"). That's
what grep, the wiki MCP, /tutor, and home-Claude are for. Credits buy code, never comprehension.

---

## 7. /stuck-protocol (/stuck) — fire on the FEELING, not after an hour of drowning 🏢 + 🏠

**Fire when:** you notice the lost feeling — re-reading the same code, aimless clicking,
the urge to procrastinate. That feeling is the trigger; don't wait to be "really" stuck.

**The craft:**
- Rung 0 catches half your cases for free: "name the next 30-minute subtask" usually
  reveals you're overwhelmed, not blocked — and gives you the subtask.
- Keep the timer honest — a real 30-minute timer, phone or terminal. Without it the
  timebox silently becomes 3 hours (this is THE failure mode the protocol exists for).
- The stuck log doubles as the question. When the box expires you copy-paste, add your
  best guess, send. No composing under stress.
- Route by weight: basics → your safe person; design/scope → my boss; batched small stuff
  → the Tue/Thu question slot.
- Set up the question slot THIS week. One sentence to my boss: *"Instead of interrupting
  you randomly, can I collect questions for a 15-minute slot Tuesdays and Thursdays?
  I'll come with what I've tried documented."* This single structure deletes the
  "disturbing people" guilt permanently.

**Common mistake:** treating asking as failure. Re-read the ladder: asking at rung 3
WITH a documented trail is the *strong* move; the silent lost day is the weak one.

---

## 8. /standup-reporter (/standup) — 5 minutes that manage your reputation 🏢

**Fire when:** every morning before standup; Friday for the weekly; always before a 1:1.

**The craft:**
- Run it, then edit ONE thing: make the "Today" line match what my boss currently cares
  about. Relevance is what makes updates land.
- Blockers: never bare. Options + leaning, or owner + age + workaround. (The skill
  enforces the phrasing — don't soften it back into "still fighting with X".)
- The weekly's "Next week: top 2 priorities as I understand them" is your misalignment
  radar — when my boss corrects it, you just saved a week of wrong work. That correction
  is a WIN, invite it.
- Keep dailies under 60 words. Long standups read as busy-not-productive.

**Common mistake:** skipping it on bad weeks. Bad weeks are exactly when a controlled,
honest, options-forward update protects you most.

---

## 9. /copilot-bridge — the unlimited planning brain 🪟 (work Windows host)

**Fire when:** every session with work Copilot (GPT). Its whole point: stop pasting
thousands of raw lines; feed it a generated context pack instead.

**The craft:**
- Once: bootstrap `.agent/PROJECT-BRIEF.md` with Copilot's help (paste the repo tree,
  co-write one page). Once: confirm with IT that your Copilot is the enterprise variant
  before pasting source.
- Per session: `./context-pack.sh <relevant files>` in the VM terminal (free) → fresh
  Copilot chat → session-opener prompt → check its 3-sentence understanding → work.
- The payoff move is prompt #5 (handoff): let GPT draft the one-shot prompt Windsurf
  will execute. Strong model plans, weak model types, you verify. Credits buy typing only.
- Never continue yesterday's chat. The pack is the memory; the chat is disposable.

**Common mistake:** trusting it about your codebase beyond what the pack shows. It's
stronger, not psychic — the one-hop verification rule still applies.

## 10. /brainstorm — before there's even a task 🏢 + 🏠

**Fire when:** an idea or open-ended ask exists but no committed approach ("make the
bot more proactive — ideas?"). Not when the task is concrete — that's /brief.

**The craft:** answer its one-at-a-time multi-choice questions honestly; demand the
2-3 alternatives before agreeing to anything; the gold output is the ready-to-send
options-plus-leaning proposal for my boss — proposing *options* is what makes a junior
read as senior. Gate: no code, no /plan, until the approach is validated (and
approved, when it's my boss's call).

## 11. /task-planner (/plan) — the credit budgeter 🏢

**Fire when:** a brief is `[READY]` and the task spans multiple files or days. Skip
for single-file tasks — the brief's §6 is enough.

**The craft:** the `[GEN]/[HAND]/[FREE]` tags ARE the skill — they decide where your
credits go before you're tempted mid-task. Every step needs a "Prove it" check; a
step that can't name one gets split. Each `[GEN]` step then goes through /token-sniper
(or Copilot drafts its prompt via bridge prompt #5). More than ~10 steps → the task
itself needs splitting; that's a conversation with the boss, with options.

## 12. /code-cartographer (/map) — the 5-repo compass 🏢

**Fire when:** a "where does X live / who consumes Y" question spans repos, or a
brief's blast radius hits unmapped territory. One-time prerequisite: add all repos to
one Windsurf workspace (File → Add Folder to Workspace) so semantic retrieval spans
the system.

**The craft:** one area per session, always the one blocking today's task — the map
grows lazily or it dies. Free recon (tree, pom.xml, entry-point greps) happens before
any paid turn; the AI only infers *purpose*, one module at a time, in YOUR words.
Cross-repo edges are the crown jewels: no edge enters SYSTEM-MAP.md without a code
anchor proving it. The payoff compounds: SYSTEM-MAP.md auto-rides into every Copilot
context pack, blast-radius answers become lookups, and six weeks in you'll be the
person who answers "what talks to what" in meetings.

## Situation → skill cheat sheet

| Situation | Run | Where |
|---|---|---|
| Idea / open-ended ask, no approach yet | /brainstorm | 🏢 + 🏠 |
| my boss assigned something | /brief | 🏢 |
| Brief READY, task is multi-file | /plan | 🏢 |
| "I don't know what this concept/service even is" | /tutor · /domain-tutor | 🏢 · 🏠 |
| About to spend credits | /token-sniper prep (or Copilot handoff prompt #5) | 🪟/🏠 → 🏢 |
| Starting a Copilot session | context-pack.sh + session opener | 🪟 |
| Need a plan / design options / diff review | copilot-bridge prompts #2/#4 | 🪟 |
| AI just generated code | /log (row) | 🏢 |
| About to commit/push | /verify | 🏢 |
| Lost / spinning / avoiding | /stuck | 🏢 + 🏠 |
| Bot ignores a tool, streaming/UI bugs | mentor pitfall tables | 🏢 + 🏠 |
| "Where does X live?" across the 5 repos | /map | 🏢 |
| Morning / Friday / before 1:1 | /standup | 🏢 |
| Review in an hour | read your decision table | 🏢 |

## Adoption plan — do NOT start all eight at once

Habits stack; grabbing all of them in week one guarantees dropping all of them by week two.

- **Week 1:** /brief on every new task + /log rows. (Understanding + paper trail.)
- **Week 2:** add /verify before every push. Send my boss the question-slot request.
- **Week 3:** add /stuck (timer!) and one /tutor note per day from the parking lot.
- **Week 4:** add /standup daily + Friday weekly. Review the month: fix-cycle count,
  credit spend, question trend. That review IS your evidence the system works.

By week 5 the loop runs itself — each skill's output feeds the next one's input, which
is the real reason it holds: the brief writes your prompts, the prompts fill the log,
the log answers my boss's "why", and the log writes your standups.
