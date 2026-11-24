#!/usr/bin/env bash
# Claude Code PreToolUse → dataviz-nudge.py (stdin: hook JSON)
set -euo pipefail

ROOT="${AGENT_BUNDLE_ROOT:-}"
if [[ -z "${ROOT}" ]]; then
  for candidate in \
    "${HOME}/repos/ubuntu-genesis/Config/.cursor" \
    "${HOME}/OneDrive/04. BNCL (Post Doc)/ubuntu-genesis/Config/.cursor"; do
    if [[ -f "${candidate}/agent-sync/hooks/dataviz-nudge.py" ]]; then
      ROOT="${candidate}"
      break
    fi
  done
fi
[[ -n "${ROOT}" ]] || exit 0

exec python3 "${ROOT}/agent-sync/hooks/dataviz-nudge.py"