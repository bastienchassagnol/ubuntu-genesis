---
name: graphify
description: "Mixed corpora (docs, papers, Quarto, images) and cross-document questions when graphify-out/graph.json exists. Code structure (callers, callees, impact) goes to CodeGraph first (.codegraph/, codegraph skill). Build at release milestones, not on every commit."
---

# /graphify

Turn a folder of documents (Quarto chapters, papers, PDFs, design notes, images) into a navigable knowledge graph with community detection, an audit trail (EXTRACTED / INFERRED / AMBIGUOUS), and three outputs: interactive HTML, GraphRAG-ready JSON and a plain-language `GRAPH_REPORT.md`.

## When to use, and when not

- Use for cross-document or mixed-corpus questions in a repository that has `graphify-out/graph.json`.
- Code questions ("What calls Y?", impact, call paths, "how does X reach Y") go to CodeGraph: use `codegraph_explore` or `codegraph explore "<question>"` when `.codegraph/` exists. Do not send them to graphify and do not rebuild the graph for them.
- Never install always-on hooks: no `graphify hook install`, no `graphify claude install`, no `--watch` (see [references/hooks.md](references/hooks.md)).

## Querying an existing graph

If `graphify-out/graph.json` exists and the question concerns the documents, answer from the graph before reading raw files:

```bash
graphify query "<question>"            # BFS, broad context (--dfs to trace a path, --budget N to cap tokens)
graphify path "<A>" "<B>"              # shortest path between two concepts
graphify explain "<concept>"           # plain-language explanation of a node
```

If `graphify-out/wiki/index.md` exists, navigate it instead of raw files. Answer only from what the graph output contains and quote `source_location` when citing a fact. Vocabulary expansion, the NetworkX fallback and `save-result` feedback are in [references/query.md](references/query.md).

## Building the graph (milestones only)

Build at a milestone (annotated git tag or R `DESCRIPTION` version bump) with
[`Config/.cursor/code-knowledge/scripts/graphify-milestone.sh`](../../code-knowledge/scripts/graphify-milestone.sh). The manual procedure (Steps 0-9: install check, detect, AST and semantic extraction, build, labelling, exports, manifest, report) is in [references/pipeline.md](references/pipeline.md). `graphify update .` (AST only, no API cost) runs only when the user asks.

Usage of the build command:

```
/graphify [<path>]                       # full pipeline (default: .)
/graphify <path> --mode deep             # richer INFERRED edges
/graphify <path> --update                # re-extract new or changed files only
/graphify <path> --cluster-only          # rerun clustering on the existing graph
/graphify <path> --directed | --no-viz | --svg | --graphml | --wiki | --mcp
/graphify <path> --neo4j | --falkordb    # Cypher export (add -push <uri> to push)
/graphify add <url> [--author "Name"] [--contributor "Name"]   # fetch a URL into ./raw
```

## Reference index

| File | Content |
| --- | --- |
| [references/pipeline.md](references/pipeline.md) | Build Steps 0-9, interpreter guard, `--update` and `--cluster-only` pointers |
| [references/github-and-merge.md](references/github-and-merge.md) | GitHub clone, cross-repo merge, monorepo flow |
| [references/transcribe.md](references/transcribe.md) | Video and audio transcription |
| [references/extraction-spec.md](references/extraction-spec.md) | Subagent extraction prompt (JSON schema, node IDs, confidence rubric) |
| [references/exports.md](references/exports.md) | Wiki, Neo4j, FalkorDB, SVG, GraphML, MCP, benchmark |
| [references/update.md](references/update.md) | `--update` and `--cluster-only` flows |
| [references/query.md](references/query.md) | `query`, `path`, `explain`, NetworkX fallback |
| [references/add-source.md](references/add-source.md) | `/graphify add <url>` |
| [references/hooks.md](references/hooks.md) | Why hooks and watchers are not used |

## Honesty rules

- Never invent an edge. If unsure, use AMBIGUOUS.
- Never skip the corpus check warning.
- Always show token cost in the report.
- Never hide cohesion scores behind symbols; show the raw number.
- Never run the HTML viz on a graph with more than 5,000 nodes without warning the user.
