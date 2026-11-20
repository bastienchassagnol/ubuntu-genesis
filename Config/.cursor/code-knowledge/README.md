# Code knowledge stack (per repo)

**CodeGraph** — local code graph, MCP auto-sync. Run once per checkout:

```bash
codegraph init
```

**Graphify** — mixed corpus graph under `graphify-out/`. Run on **milestones**
only, not every commit.

| Trigger | Script |
| --- | --- |
| Git annotated tag | [`scripts/tag-release.sh`](scripts/tag-release.sh) |
| R `DESCRIPTION` version bump (optional hook) | [`hooks/post-commit-graphify-milestone.example`](hooks/post-commit-graphify-milestone.example) |
| Manual | [`scripts/graphify-milestone.sh`](scripts/graphify-milestone.sh) |

## Gitignore

Add to the project `.gitignore`:

```
.codegraph/
graphify-out/
```

## Bootstrap from this bundle

```bash
./Config/.cursor/code-knowledge/install-project.sh
```

Copies [`templates/codegraph.json`](templates/codegraph.json) when missing.
Optionally installs the DESCRIPTION milestone hook (interactive).

## Agents

Routing is in `code-intelligence.mdc`. Laptop edits in `~/.claude/` →
`agent-sync.sh publish` → commit `Config/.cursor/`.

See also [`docs/agent/code-knowledge-stack.md`](../../docs/agent/code-knowledge-stack.md).