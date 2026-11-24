# Agent orientation (ubuntu-genesis)

This repository is a **Quarto website** of installation guides (Ubuntu,
software, network, OneDrive, R, Git, LaTeX). It also holds the agent bundle
(rules and skills) that Cursor and Claude Code use in every project. It is
not the DeCovarT package.

## Layout and conventions

- Pages at the root (`index.qmd`, `ubuntu.qmd`, `software.qmd`, `network.qmd`,
  `onedrive.qmd`, `r.qmd`, `git.qmd`, `latex.qmd`) and `_quarto.yml`. Adding a
  page: link it from `index.qmd` and keep `project.render` and the navbar in
  sync.
- `assets/<topic>/`: figures, scripts and PDFs. `assets/agents/` holds the
  TikZ sources of the rules and skills maps (`latex-scientific` SVG-first
  workflow).
- `Config/`: portable dotfiles and the agent bundle `Config/.cursor/`
  (rules, skills, `agent-sync`, `code-knowledge`). No secrets or
  machine-specific paths there.
- `docs/` is rendered HTML, gitignored; GitHub Actions publishes `gh-pages`.
- Bibliography: page-level `.bib` files for now; a site-wide split will be
  `bibliography/packages.bib` + `bibliography/REFERENCES.bib`. Curate exported
  literature with `bib_enrich.py` from `scripts/curate_bibliography/`
  (installed by `scripts/install_curate_bibliography.sh`), not
  `check_bibliography.py --clean` (package layouts only).

## Agent bundle

| Layer | Path |
| --- | --- |
| Git source of truth | [`Config/.cursor/`](Config/.cursor/) (`rules/*.mdc`, `skills/`) |
| User deploy | `~/.cursor/rules`, `~/.cursor/skills`, `~/.claude/rules`, `~/.claude/skills` |
| This project | `.cursor/rules` and `.cursor/skills` symlink to the bundle |

Do not edit `~/.cursor/skills-cursor/` (Cursor built-ins). See
[`Config/.cursor/README.md`](Config/.cursor/README.md) for the rule and skill
list, the two maps, packs and hooks.

```yaml
# read by agent-sync install-project
packs:
  - user-global
project_rules: symlink
```

```bash
export AGENT_BUNDLE_ROOT="/path/to/ubuntu-genesis/Config/.cursor"
"${AGENT_BUNDLE_ROOT}/agent-sync/agent-sync.sh" install-user
"${AGENT_BUNDLE_ROOT}/agent-sync/agent-sync.sh" verify
# after editing ~/.claude or ~/.cursor: publish, then commit Config/.cursor
"${AGENT_BUNDLE_ROOT}/agent-sync/agent-sync.sh" publish
```

Hooks keep the copies in step: a Claude Code or Cursor edit under
`Config/.cursor` (or a home rule/skill) redeploys, a new Claude Code session
runs `verify`, and `git pull` redeploys once
`git config core.hooksPath Config/.cursor/agent-sync/git/hooks` is set.

## MMG cluster (account `bastienc`, not `bastien`)

1. `git clone https://github.com/bastienchassagnol/ubuntu-genesis.git ~/repos/ubuntu-genesis`
2. Set `core.hooksPath` as above; each `git pull` then runs `install-user`
   (or run it by hand with `AGENT_BUNDLE_ROOT=~/repos/ubuntu-genesis/Config/.cursor`).
3. Smoke test: `agent-sync.sh verify`.
4. From the laptop: `AGENT_SYNC_HOST=bastienc@<mmg-host> AGENT_REMOTE_REPO=~/repos/ubuntu-genesis ./Config/.cursor/agent-sync/agent-sync.sh install-remote`.

Remote SSH agents read `/home/bastienc` only. Details:
[`Config/.cursor/agent-sync/CLUSTER.md`](Config/.cursor/agent-sync/CLUSTER.md).

## Code intelligence

CodeGraph (`.codegraph/`) for code; Graphify (`graphify-out/`) only at
milestones (git tags, R `DESCRIPTION` version bumps). Routing: rule
`code-intelligence`. Bootstrap another repository with
`./Config/.cursor/code-knowledge/install-project.sh` then `codegraph init`.
