# Agent orientation (ubuntu-genesis)

Quarto teaching website. Standing guidance for Cursor and Claude Code:

| Layer | Path |
| --- | --- |
| **Git source of truth** | [`Config/.cursor/`](Config/.cursor/) rules (`.mdc`) and vendored skills |
| **User deploy** | `~/.cursor/rules`, `~/.cursor/skills`, `~/.claude/rules`, `~/.claude/skills` |
| **This project** | [`.cursor/rules`](.cursor/rules) → symlink to `Config/.cursor/rules` |

Do **not** edit `~/.cursor/skills-cursor/` or project-specific DeCovarT skills in other trees; they are not part of this bundle.

## Sync commands

```bash
export AGENT_BUNDLE_ROOT="/path/to/ubuntu-genesis/Config/.cursor"
"${AGENT_BUNDLE_ROOT}/agent-sync/agent-sync.sh" install-user
"${AGENT_BUNDLE_ROOT}/agent-sync/agent-sync.sh" verify
```

After editing rules in `~/.claude` or `~/.cursor`, publish back to git:

```bash
"${AGENT_BUNDLE_ROOT}/agent-sync/agent-sync.sh" publish
# then commit under Config/.cursor
```

```yaml
# agent-sync manifest (read by install-project)
packs:
  - user-global
project_cursor:
  rules: symlink
  skills: symlink
```

## MMG cluster (account `bastienc`, not `bastien`)

1. Clone: `git clone https://github.com/bastienchassagnol/ubuntu-genesis.git ~/repos/ubuntu-genesis`
2. After each `git pull`:  
   `AGENT_BUNDLE_ROOT=~/repos/ubuntu-genesis/Config/.cursor ~/repos/ubuntu-genesis/Config/.cursor/agent-sync/agent-sync.sh install-user`
3. Smoke test: same path, `agent-sync.sh verify`
4. Optional from laptop: `AGENT_SYNC_HOST=bastienc@<mmg-host> AGENT_REMOTE_REPO=~/repos/ubuntu-genesis ./Config/.cursor/agent-sync/agent-sync.sh install-remote`

Remote SSH agents read **`/home/bastienc`** only; they do not see the laptop home.

## Hooks (optional)

- Cursor user hook: copy [`Config/.cursor/agent-sync/hooks/cursor-hooks.json.example`](Config/.cursor/agent-sync/hooks/cursor-hooks.json.example) to `~/.cursor/hooks.json` and install [`agent-sync-after-edit.sh`](Config/.cursor/agent-sync/hooks/agent-sync-after-edit.sh) under `~/.cursor/hooks/`.
- Claude Code: merge [`claude-settings-hooks.snippet.json`](Config/.cursor/agent-sync/hooks/claude-settings-hooks.snippet.json) into `~/.claude/settings.json`.
- Git: `git config core.hooksPath Config/.cursor/agent-sync/git/hooks` in this repo.