# MMG cluster deploy

Linux account on the cluster: **`bastienc`** (laptop: `bastien`).

## One-time setup

```bash
git clone https://github.com/bastienchassagnol/ubuntu-genesis.git ~/repos/ubuntu-genesis
cd ~/repos/ubuntu-genesis
git config core.hooksPath Config/.cursor/agent-sync/git/hooks
chmod +x Config/.cursor/agent-sync/git/hooks/*
chmod +x Config/.cursor/agent-sync/agent-sync.sh
AGENT_BUNDLE_ROOT="$PWD/Config/.cursor" ./Config/.cursor/agent-sync/agent-sync.sh install-user
AGENT_BUNDLE_ROOT="$PWD/Config/.cursor" AGENT_PROJECT_ROOT="$PWD" \
  ./Config/.cursor/agent-sync/agent-sync.sh verify
```

## CodeGraph (user-global, not in git)

Per-project code graphs (`codegraph init`) live under each repo’s `.codegraph/`.
The CLI and MCP wiring are installed once per account (`bastienc` on MMG).

```bash
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
# new shell so ~/.local/bin is on PATH
codegraph telemetry off
codegraph install --target=cursor,claude --yes
```

Then, in each repo you work in:

```bash
cd ~/repos/ubuntu-genesis   # or an R package checkout
codegraph init
```

Optional: copy or adapt `codegraph.json` from
[`Config/.cursor/code-knowledge/templates/codegraph.json`](../code-knowledge/templates/codegraph.json).
Restart Cursor / Claude Code after the first `codegraph install`.

## Routine

```bash
cd ~/repos/ubuntu-genesis && git pull --ff-only
# post-merge hook runs install-user, or run manually:
AGENT_BUNDLE_ROOT=~/repos/ubuntu-genesis/Config/.cursor \
  ~/repos/ubuntu-genesis/Config/.cursor/agent-sync/agent-sync.sh install-user
```

## Optional login check

Add to `~/.bashrc` on the cluster:

```bash
if [[ -n "${CLAUDE_AGENT_SYNC:-}" ]] && [[ -x "$HOME/repos/ubuntu-genesis/Config/.cursor/agent-sync/agent-sync.sh" ]]; then
  AGENT_BUNDLE_ROOT="$HOME/repos/ubuntu-genesis/Config/.cursor" \
    "$HOME/repos/ubuntu-genesis/Config/.cursor/agent-sync/agent-sync.sh" verify || true
fi
```

Then run `CLAUDE_AGENT_SYNC=1 bash -l` before a long session.