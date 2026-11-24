# graphify reference: hooks are not used

Do not run `graphify hook install`, `graphify claude install` or `--watch`: always-on rebuilds duplicate CodeGraph (which auto-syncs code) and spend LLM budget on every commit.
Build the graph at milestones with `Config/.cursor/code-knowledge/scripts/graphify-milestone.sh`; run `graphify update .` (AST only) only when the user asks.
