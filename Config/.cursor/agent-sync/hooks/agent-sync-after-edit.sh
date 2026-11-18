#!/usr/bin/env bash
# Cursor afterFileEdit hook: thin wrapper — logic lives in agent-sync.sh
set -euo pipefail

ROOT="${AGENT_BUNDLE_ROOT:-}"
if [[ -z "${ROOT}" ]]; then
  for candidate in \
    "${HOME}/repos/ubuntu-genesis/Config/.cursor" \
    "${HOME}/OneDrive/04. BNCL (Post Doc)/ubuntu-genesis/Config/.cursor"; do
    if [[ -x "${candidate}/agent-sync/agent-sync.sh" ]]; then
      ROOT="${candidate}"
      break
    fi
  done
fi
[[ -n "${ROOT}" ]] || exit 0

path="${1:-}"
if [[ -z "${path}" ]] && [[ ! -t 0 ]]; then
  input="$(cat)" || true
  if command -v jq >/dev/null 2>&1 && [[ -n "${input}" ]]; then
    path="$(printf '%s' "${input}" | jq -r '.file_path // .path // empty' 2>/dev/null || true)"
  fi
fi

"${ROOT}/agent-sync/agent-sync.sh" after-edit "${path}"