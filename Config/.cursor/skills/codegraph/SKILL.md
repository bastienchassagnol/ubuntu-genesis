---
name: codegraph
description: Local code knowledge graph for agents. Use when .codegraph/ exists and the user asks about call graphs, impact, routing, or how symbols connect across source files—before grepping or reading whole trees.
---

# CodeGraph

Pre-indexed, local code graph with MCP tool `codegraph_explore`. Auto-syncs on
file changes while the MCP server runs. Official docs:
<https://colbymchenry.github.io/codegraph/>

Routing between CodeGraph and Graphify: rule `code-intelligence`.

## When to use

- “Who calls X?”, “What breaks if I change Y?”, “How does a request reach Z?”
- Finding symbols across a repo without a file crawl
- R, Python, Shell, TypeScript, and other supported languages in the same project

Skip CodeGraph when only prose (`.qmd` narrative) matters and no
`.codegraph/` index exists—offer `codegraph init` or milestone Graphify.

## One-time per machine

```bash
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
codegraph telemetry off   # optional
codegraph install --target=cursor,claude --yes
```

Restart Cursor / Claude Code after install.

## One-time per project

```bash
cd /path/to/repo
# optional: copy Config/.cursor/code-knowledge/templates/codegraph.json
codegraph init
codegraph status
```

## Agent usage

Prefer MCP `codegraph_explore` with a natural-language question. CLI equivalent:

```bash
codegraph explore "How does X reach Y?"
codegraph impact MyFunction --depth 2
codegraph query ModuleName --limit 20
```

Treat returned source as already read. If a staleness banner appears after an
edit, read that file directly once, then re-query.

## Optional `codegraph.json` (project root)

Deprioritise agent bundle or script trees so product code ranks first:

```json
{
  "deprioritize": ["Config/.cursor/", "scripts/"]
}
```

Re-index after changes: `codegraph index`.

## Do not

- Run `graphify hook install` for code sync; CodeGraph handles that
- Assume multi-repo Cypher queries (solo-repo default)

## Uninstall

`codegraph uninstall` removes MCP config; `codegraph uninit` removes a project
index (`.codegraph/`).