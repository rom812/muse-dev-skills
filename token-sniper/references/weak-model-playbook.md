# Weak-Model Playbook

How to get strong-model results from older/weaker models (work Windsurf: Opus/Sonnet 4.x era),
and how to avoid being misled when you can't yet judge the output yourself.

## The one mental shift that changes everything

A practitioner who builds production pipelines on "weak" models puts it this way:
**"You're not giving them instructions; you're not talking to them; you're creating a
pattern that they can follow."** Weak models are much closer to autocomplete than strong
ones — they imitate far better than they reason. Every tactic below follows from this.

## Getting good output

1. **Precedent beats instructions, always.** Point at the nearest existing file
   ("follow the pattern of `LinkDeletedTrigger.java`") — for a weak model this is worth
   more than a page of requirements. If no repo precedent exists, paste the relevant
   pattern from spring-ai-mentor / vaadin-mentor references into the prompt.
2. **Two examples minimum, when showing examples.** Research and practice agree: one
   example causes overfitting to its specifics (sometimes worse than none); two or more
   establish the pattern.
3. **Decompose ruthlessly.** Weak models fail on multi-step leaps and are fine on single
   steps. Big task → plan-only shot (template C) → generate step by step. Never ask a
   weak model to design AND implement in one prompt.
4. **Anchor the era.** Older models default to their training data's version of your
   stack: pre-1.0 Spring AI (`FunctionCallback`), older Vaadin idioms. Open the prompt
   with the anchor: "Spring Boot 3, Vaadin 24, Spring AI 1.0 — use @Tool, not
   FunctionCallback" — or better, show the correct pattern (rule 1).
5. **Constrain the output.** "Modify only <files>. Do not refactor anything else. No
   placeholders/TODOs. Output full file contents." Weak models drift into unrequested
   changes exactly where strong ones don't.
6. **Fresh chat per problem.** Long conversations degrade weak models fast ("a super
   advanced senior wearing a blindfold — gets confused quickly after you tell it
   things"). When a chat gets muddled, don't argue with it: restate context cleanly in
   a NEW chat. Continuing a confused chat is paying for confusion.
7. **Iterate the prompt, not the argument.** When output fails, the fix goes into the
   next prompt as an added example/constraint — not into a "no, you're wrong" reply.

## Not getting misled (defenses for when you can't judge the output)

1. **Know which mistakes are dangerous** (Simon Willison): hallucinated APIs and
   invented methods are the LEAST dangerous — the compiler catches them loudly. The
   dangerous mistakes are **code that runs but does the wrong thing**. So compiling is
   not verification. His rule: *"never trust any piece of code until you've seen it
   work with your own eye — or better, seen it fail and then fixed it."* Run the real
   flow in the app. Every time.
2. **Fluency ≠ correctness.** Weak models are exactly as confident when wrong. Good
   naming, clean comments, and a sure tone tell you NOTHING — that's how answers look,
   not whether they're true. Never let "it looks professional" substitute for a check.
3. **Never ask "is this right?"** Models — weak ones especially — agree with you
   (sycophancy). Ask the attacking question instead: "What's wrong with this approach?
   In which cases does this code fail?" Or cross-examine: same question, fresh chat
   (or home Claude, abstractly), phrased from the opposite side. Two independent
   answers disagreeing = you found the misleading spot before it found you.
4. **One verification hop for any claim about YOUR codebase.** If the model says
   "this service works like X", open the actual method before building on it. AI
   explanations of unfamiliar code are the highest-risk mislead for a newcomer, because
   you can't smell the error yet.
5. **Claim-type trust ladder** — where a check is mandatory:
   | Claim type | Check |
   |---|---|
   | Syntax/boilerplate | compiler (free) |
   | API exists / signature | compiler + one docs glance |
   | "Your codebase does X" | open the code — mandatory hop |
   | Domain/telecom fact | wiki / knowledge note / Danny |
   | Design choice ("best way is…") | precedent in repo; if none, it's a Danny-question, not an AI answer |
6. **The error-feedback loop trap.** Feeding errors back can produce fresh hallucinations
   forever — devs report endless loops where every "fix" invents new problems. Hence the
   two-shot cap (SKILL.md step 4): after two failed prepared shots, the problem is
   under-understood → back to /brief or /tutor, or dig in by hand.
