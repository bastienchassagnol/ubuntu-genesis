# Cursor configuration bundle (teaching_material)

Portable **rules** (`.mdc`) and **skills** (`SKILL.md`) for Cursor Agent,
split by domain instead of one `.cursorrules` file.

## Rules (`rules/`)

| File | When it applies |
|------|-----------------|
| `scope-workspace.mdc` | Always — scope, data, SSH/editor hosts |
| `statistical-modelling.mdc` | Always — CV, bootstrap, glmPerm, mlr3, review |
| `documentation-bibliography.mdc` | Always — Zotero, Quarto bib, intake |
| `scientific-writing.mdc` | Always — voice, figures, integrity |
| `r-development.mdc` | `*.R` — local layout, style, ggplot2, parallelism |
| `r-package-development.mdc` | `DESCRIPTION`, tests, CRAN, GHA, pkgdown |
| `python-development.mdc` | `*.py`, `pyproject.toml` — uv, Ruff, ty |
| `quarto-presentations.mdc` | `*.qmd`, slides — Mermaid, reveal.js |
| `latex-scientific.mdc` | `*.tex` — LuaLaTeX, TikZ, minted |
| `data-visualisation.mdc` | Charts in R, Python, Quarto, LaTeX |
| `document-extraction.mdc` | anydoc → Markdown; Docling/Chroma `doc-search`; `.qmd` |
| `figure-sources.mdc` | Always — reuse, draw, then generate a figure |
| `graphical-models.mdc` | Plate notation in Quarto and LaTeX |
| `graphify.mdc` | When `graphify-out/` exists: corpus queries (not daily code) |
| `ponytail.mdc` | Prefer the smallest change that works |
| `symbolic-verification.mdc` | Check rearranged equations before calling them verified |
| `token-budget.mdc` | Always — route work so documents are not loaded whole |
| `code-intelligence.mdc` | Always — CodeGraph vs Graphify routing |
| `teaching-material-repo.mdc` | This Quarto website layout |

## Skills (`skills/`)

| Skill | Role |
|-------|------|
| `deslop` | De-AI prose (LaTeX-safe) |
| `peer-review` | OSP first; Firecrawl report second tier |
| `quarto` | Slides, websites, and Observable JS |
| `quarto-revealjs` (+ fragment, auto-animate) | Slide decks |
| `data-visualisation` | Chart choice and the dataviz caveats |
| `codegraph` | Structural code queries when `.codegraph/` exists |
| `graphify` | Mixed corpora when `graphify-out/` exists (milestone builds) |
| `find-skills` | Discover third-party skills |
| `instagram-carousel` | Carousel copy/layout |
| `react-and-nextjs-data-visualization` | Charts inside React and Next.js |
| `testing-data-visualizations` | Visual tests for charts and dashboards |
| `firecrawl` | **Pointer only** — install from [firecrawl/skills](https://github.com/firecrawl/skills) |

These copies follow `~/.claude/rules` and `~/.claude/skills`. Firecrawl
sub-skills are symlinks on this machine and are **not** vendored here
(repo size, API keys). Follow `skills/firecrawl/SKILL.md`.

## Installation (user home)

Git source of truth: this folder. Deploy with **agent-sync** (laptop and MMG cluster):

```bash
export AGENT_BUNDLE_ROOT="/path/to/ubuntu-genesis/Config/.cursor"
"$AGENT_BUNDLE_ROOT/agent-sync/agent-sync.sh" install-user
"$AGENT_BUNDLE_ROOT/agent-sync/agent-sync.sh" verify
```

After editing `~/.cursor` or `~/.claude`, copy changes back before commit:

```bash
"$AGENT_BUNDLE_ROOT/agent-sync/agent-sync.sh" publish
```

See [`agent-sync/CLUSTER.md`](agent-sync/CLUSTER.md) for the **`bastienc`** cluster account and
[`../../AGENTS.md`](../../AGENTS.md) for project hooks and packs.

Optional **User Rules** one-liner (Cursor → Settings → Rules):

> Apply `~/.cursor/rules/*.mdc` unless the project overrides in `.cursor/rules/`.

Optional repo root **`AGENTS.md`**: onboarding only (commands, data paths);
does not replace `.mdc` rules.

## Also in this folder

- `Code/User/` — VS Code / Cursor settings and keybindings templates
- `extensions/list.txt` — extension IDs
- `archive/.cursorrules.decovart-monolith` — retired single-file rules

## Diagram

![Rules and skills layout](cursorrules-map.png)
