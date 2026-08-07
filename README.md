# muse-dev-skills

A personal skill set + workflow system for working on the Muse chatbot (Spring Boot + Spring AI)
as a junior developer with a **limited AI budget** and a **new, unfamiliar domain**.

The system attacks six problems at once:

1. **"I start coding before I understand the feature"** → `feature-brief` forces understanding first.
2. **"The domain is new to me"** → `domain-tutor` builds a personal knowledge base, one note per concept.
3. **"I rely on AI output I can't explain, then fix endlessly"** → `explain-before-merge` is a hard gate.
4. **"Nobody sees my progress"** → `impl-log` + `standup-reporter` turn work into visible evidence.
5. **"I rebuilt something that already existed"** → `precedent-check` sweeps before you write, and
   `corrections-ledger` makes sure no correction has to be given twice.
6. **"New requirements only appear at the demo"** → `demo-prep` predicts them, states scope first,
   and captures every late ask with a date.

## The skills

| Skill | What it does | When to run |
|-------|--------------|-------------|
| **[brainstorm](brainstorm/)** | Explore a vague idea into a validated approach: one question at a time, 2-3 alternatives with trade-offs, incremental design check. Feeds feature-brief or a proposal for the boss. | Idea/open ask, no committed approach |
| **[feature-brief](feature-brief/)** | Turn a vague task from your boss into a one-page brief: problem, affected services, acceptance criteria, smart clarifying questions. **No code before a brief exists.** | The moment you get a task |
| **[task-planner](task-planner/)** | Decompose a READY brief into one-shot-sized steps tagged [GEN]/[HAND]/[FREE] — the plan doubles as your credit budget. | Multi-file/multi-day tasks, after the brief |
| **[domain-tutor](domain-tutor/)** | Teach yourself one domain concept (a Muse service, topology, a domain term) and save a permanent knowledge note in your own words — runtime flows belong to flow-tracer. | Whenever the brief reveals a gap |
| **[impl-log](impl-log/)** | Log every implementation: what AI generated, what you verified, what broke, what you learned. Your "harness the AI" journal. | During + after every task |
| **[explain-before-merge](explain-before-merge/)** | Verification gate: explain every changed line, trace the flow, check edge cases, generate the PR description. | Before every commit |
| **[spring-ai-mentor](spring-ai-mentor/)** | Reference knowledge for Spring AI (tool calling, advisors, ChatClient, memory) — compensates for older models that don't know the framework. | When touching Spring AI code |
| **[vaadin-mentor](vaadin-mentor/)** | Reference knowledge for Vaadin Flow: background-thread UI updates (UI.access/@Push), scopes, streaming into components, JS/audio integration for STT/TTS/avatar. | When touching the UI |
| **[token-sniper](token-sniper/)** | Prompt-under-budget discipline: prepare offline, one-shot, never enter "fix it" loops. | Every time you're about to spend work AI credits |
| **[standup-reporter](standup-reporter/)** | Turn your logs into crisp updates for your boss: done / in progress / blockers-with-options. | Daily + Friday |
| **[stuck-protocol](stuck-protocol/)** | Escalation ladder for being stuck: timeboxed attempts with a documented trail → well-formed question with a best guess. Plus question-slot and parking-lot habits. | The moment you feel lost |
| **[copilot-bridge](copilot-bridge/)** | Use the unlimited chat-only strong model as the planning brain: context packs instead of raw-code pastes, stateless sessions, handoff prompts to Windsurf. Includes `context-pack.sh`. | Every Copilot session |
| **[code-cartographer](code-cartographer/)** | Living maps of a multi-repo system: CODEMAP per repo + cross-repo SYSTEM-MAP with anchored edges. Incremental, free-recon-first, one area per session. | "Where does X live?" across repos |
| **[flow-tracer](flow-tracer/)** | Trace one runtime flow into a verified call-chain note: real Class.method steps, data shapes, async/repo boundaries — verified vs ⚠ inferred markers, never trace the same flow twice. | "What happens when X?" moments |
| **[precedent-check](precedent-check/)** | Four-angle sweep (name, type signature, call site, test) for an existing util/converter/helper before you write a new one. Runs as a cheap read-only subagent. **No new generic-suffix class without a verdict.** | Before writing any shared code |
| **[corrections-ledger](corrections-ledger/)** | Every correction into one durable file, generalised into a rule that fires again; consulted before every PR and demo. Repeat corrections get escalated into hard rules. | The moment anyone corrects you |
| **[demo-prep](demo-prep/)** | For a boss who specifies requirements at the demo: rehearsed path, scope statement said first, five predicted "can you also…" asks with bucketed answers, gaps disclosed up front, new asks captured with dates. | Before any demo or review |

**The master loop that ties them together: [WORKFLOW.md](WORKFLOW.md).** Read it first.
**How to run each skill well (invocations, examples, common mistakes): [GUIDE.md](GUIDE.md).**

## Install

> **Note (owner's machines): the skills are ALREADY INSTALLED** — all skills in
> `~/.claude/skills/` at home, and the Windsurf workflows/rules in the work repo.
> Re-running an installer is always safe: it overwrites with the latest version
> (that's how updates ship). Agents: finding existing copies is expected, not an error.

### Companion skills (installed separately, not part of this repo)

From [LiozShor/claude-code-skills](https://github.com/LiozShor/claude-code-skills) (MIT):

```bash
# skill review/improvement + skill creation — install BOTH (they share scripts)
npx skills add LiozShor/claude-code-skills@skill-improver -g -y
npx skills add LiozShor/claude-code-skills@skills-build -g -y
```

### Claude Code (home — your heavy-reasoning environment)

```bash
# all skills, globally
./install.sh claude
```

Then invoke with `/feature-brief`, `/domain-tutor`, etc.

### Windsurf / Devin Desktop (work — your limited-budget environment)

Installs the **same skill files** as Claude Code, plus rules and slash-command shims:

```bash
# per-project (also adds .agent/ to the repo's local-only ignore)
./install.sh windsurf <path-to-work-repo>

# or global (all projects, survives repo switches)
./install.sh windsurf-global
```

Then invoke with `/brainstorm`, `/brief`, `/plan`, `/precedent`, `/verify`, `/log`,
`/trace`, `/map`, `/tutor`, `/stuck`, `/standup`, `/ledger`, `/demo`, `/sniper`,
`/bridge`. (`spring-ai-mentor` and `vaadin-mentor` have no slash command by design —
they load automatically via the `model_decision` rules in `.windsurf/rules/`.)

**Re-running the installer is the supported upgrade path.** It replaces every skill it
manages, prunes skills an earlier version shipped that are no longer part of the set,
and writes `.agent/muse-manifest` recording the installed commit. To confirm an upgrade
actually landed, check that `version_sha` in that manifest matches `git rev-parse
--short HEAD` in this repo — a skill folder merely existing does not prove it is current.

Prefer to have the agent run the installation itself? Paste the ready-made prompt from
[windsurf/cascade-install-prompt.md](windsurf/cascade-install-prompt.md) — it now
includes the manifest-vs-HEAD check as its pass criterion.

> **One source of truth: `SKILL.md`.** Windsurf became **Devin Desktop** on 2026-06-02,
> and both its agents read `SKILL.md` natively — Devin scans `.windsurf/skills/`,
> `.devin/skills/`, `.agents/skills/`, `.claude/skills/` and four more paths. There is
> no longer a compact "port" to maintain: the work repo gets the full skills.
>
> **Cascade is legacy; Devin Local became the default after 2026-07-01, and it does not
> support Workflows or Memories** ([docs](https://docs.devin.ai/desktop/devin-local):
> *"Migrate your workflows to skills"*). The files in `windsurf/workflows/` are now
> 6-line shims that just invoke the matching skill — they exist only so `/brief`-style
> slash commands keep working on legacy Cascade, which cannot auto-invoke skills.
> On Devin Local the skills run directly, and they can fire on their own.
>
> Because memories no longer persist between sessions, anything durable belongs in a
> skill or a rule — that is what `corrections-ledger` is for.
>
> Portability note: Devin tool names are lowercase (`read`, `grep`, `exec`) and Claude's
> are capitalised, so no single `allowed-tools:` value works in both. These skills omit
> the field entirely and rely on the default (full access) in each tool.

### Recommended third-party skills (install once, free knowledge)

```bash
npx skills add github/awesome-copilot@java-springboot -g -y            # 17K installs, Spring Boot conventions
npx skills add affaan-m/everything-claude-code@codebase-onboarding -g -y  # 5K installs, repo onboarding
npx skills add giuseppe-trisciuoglio/developer-kit@spring-ai-mcp-server-patterns -g -y
```

## Where your work artifacts live

Skills write briefs/logs/notes into a `.agent/` folder **inside whatever project you're working in**:

```
<project>/.agent/
├── briefs/        # feature briefs (one per task) + demo cards (NNN-<task>-demo.md)
├── design-logs/   # global INDEX.md + one dir per feature (impl logs + feature INDEX.md), one shared number sequence with design logs
└── knowledge/     # domain notes (one per concept)
    ├── corrections.md   # the corrections ledger — read before every PR and demo
    └── traces/          # verified call-chain notes + INDEX.md
```

**At work, keep `.agent/` out of the shared repo without touching the team's .gitignore:**

```bash
echo ".agent/" >> .git/info/exclude   # local-only ignore, invisible to teammates
```

## ⚠️ Confidentiality — read this once, seriously

- Your **employer's code and internal docs are confidential**. Do not paste proprietary code,
  wiki content, or topology data into personal AI accounts or push work-derived notes to
  personal GitHub repos unless your company policy explicitly allows it.
- This repo holds the **framework** (skills, templates, workflow). It is generic on purpose.
- Knowledge notes you write **at work stay at work** (that's why `.agent/` lives in the work
  project, not here). Notes written *in your own words* are also how you actually learn.
- When using Claude at home to think through a work problem, describe the problem
  **abstractly** ("a Spring AI tool that reacts to a topology event") — never paste the code.

## Credits

- The impl-log/feature-brief lifecycle is adapted from
  [LiozShor/claude-code-skills](https://github.com/LiozShor/claude-code-skills) `design-log`
  (itself extending Yoav Abrahami's Design-Log Methodology) — simplified for a junior-dev,
  low-token workflow.
- The brief→plan→implement gating mirrors [GitHub Spec Kit](https://github.com/github/spec-kit)'s
  specify/plan/tasks/implement phases.
