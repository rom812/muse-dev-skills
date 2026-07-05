# muse-dev-skills

A personal skill set + workflow system for working on the Muse chatbot (Spring Boot + Spring AI)
as a junior developer with a **limited AI budget** and a **new, unfamiliar domain**.

The system attacks four problems at once:

1. **"I start coding before I understand the feature"** → `feature-brief` forces understanding first.
2. **"The domain is new to me"** → `domain-tutor` builds a personal knowledge base, one note per concept.
3. **"I rely on AI output I can't explain, then fix endlessly"** → `explain-before-merge` is a hard gate.
4. **"Nobody sees my progress"** → `impl-log` + `standup-reporter` turn work into visible evidence.

## The skills

| Skill | What it does | When to run |
|-------|--------------|-------------|
| **[feature-brief](feature-brief/)** | Turn a vague task from your boss into a one-page brief: problem, affected services, acceptance criteria, smart clarifying questions. **No code before a brief exists.** | The moment you get a task |
| **[domain-tutor](domain-tutor/)** | Teach yourself one domain concept (a Muse service, topology, a flow) and save a permanent knowledge note in your own words. | Whenever the brief reveals a gap |
| **[impl-log](impl-log/)** | Log every implementation: what AI generated, what you verified, what broke, what you learned. Your "harness the AI" journal. | During + after every task |
| **[explain-before-merge](explain-before-merge/)** | Verification gate: explain every changed line, trace the flow, check edge cases, generate the PR description. | Before every commit |
| **[spring-ai-mentor](spring-ai-mentor/)** | Reference knowledge for Spring AI (tool calling, advisors, ChatClient, memory) — compensates for older models that don't know the framework. | When touching Spring AI code |
| **[token-sniper](token-sniper/)** | Prompt-under-budget discipline: prepare offline, one-shot, never enter "fix it" loops. | Every time you're about to spend work AI credits |
| **[standup-reporter](standup-reporter/)** | Turn your logs into crisp updates for your boss: done / in progress / blockers-with-options. | Daily + Friday |

**The master loop that ties them together: [WORKFLOW.md](WORKFLOW.md).** Read it first.

## Install

### Claude Code (home — your heavy-reasoning environment)

```bash
# all skills, globally
./install.sh claude
```

Then invoke with `/feature-brief`, `/domain-tutor`, etc.

### Windsurf (work — your limited-budget environment)

Copy the compact ports into the work repo (or your global workflows dir):

```bash
# per-project (also adds .agent/ to the repo's local-only ignore)
./install.sh windsurf <path-to-work-repo>

# or global (all projects, survives repo switches)
./install.sh windsurf-global
```

Then invoke with `/brief`, `/tutor`, `/verify`, `/log`, `/standup` in Cascade.

> Windsurf workflows are capped at 12,000 characters — the ports in `windsurf/` are
> deliberately compact. The full-fat versions live in the skill folders.

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
├── briefs/       # feature briefs (one per task)
├── logs/         # implementation logs (one per task)
└── knowledge/    # domain notes (one per concept)
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
