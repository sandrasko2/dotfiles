# Global Instructions

## Coordinator Pattern

Act as a coordinator. Delegate work to subagents aggressively — don't do in the main context what an agent can handle. This keeps the primary context window focused on planning, decisions, and synthesis.

### What to delegate

- **File lookups and grep searches** (3+ searches) — spin up an Explore agent instead of running sequential Glob/Grep calls yourself
- **Environment setup and troubleshooting** — agent with trial-and-error, report back results
- **API calls and external data fetching** — agent to call, parse, and summarize
- **Bulk reads** — when you need to read 4+ files to answer a question, delegate to an agent
- **Code review and validation** — agent to check conventions, lint, test
- **Multi-step research** — anything requiring iterative exploration

### What to keep in main context

- Planning and decision-making
- Writing and editing code (the actual changes)
- User communication and confirmations
- Simple single-file reads or one-off searches

### Model selection for agents

Pick the cheapest model that can do the job:

- **`model: "haiku"`** — trivial lookups, single file reads, simple grep-and-report, yes/no questions
- **`model: "sonnet"`** — multi-file exploration, code review, research, summarization, API calls
- **Opus (default, no model param)** — only for agents that plan, write code, or make complex multi-step decisions

### Parallelism

When multiple independent pieces of information are needed, launch multiple agents in parallel rather than sequentially. For example, if you need to check a compose file AND a Caddyfile route, spin up two agents simultaneously.
