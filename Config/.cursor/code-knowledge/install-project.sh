#!/usr/bin/env bash
# Bootstrap CodeGraph + optional Graphify hooks for the current git repo.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

BUNDLE="${ROOT}/Config/.cursor/code-knowledge"
TEMPLATE="${BUNDLE}/templates/codegraph.json"

if [[ -f "$TEMPLATE" ]] && [[ ! -f codegraph.json ]]; then
  cp "$TEMPLATE" codegraph.json
  echo "Wrote codegraph.json from bundle template"
elif [[ -f codegraph.json ]]; then
  echo "codegraph.json already exists"
fi

if ! grep -q '^\.codegraph/' .gitignore 2>/dev/null; then
  {
    echo ""
    echo "# CodeGraph / Graphify (local indexes)"
    echo ".codegraph/"
    echo "graphify-out/"
  } >> .gitignore
  echo "Appended .codegraph/ and graphify-out/ to .gitignore"
fi

chmod +x "${BUNDLE}/scripts/"*.sh 2>/dev/null || true

if command -v codegraph >/dev/null 2>&1; then
  if [[ -d .codegraph ]]; then
    echo "codegraph: .codegraph/ present ($(codegraph status 2>/dev/null | head -3 || true))"
  else
    echo "Next: codegraph init"
  fi
else
  echo "codegraph: install CLI (see CLUSTER.md / codegraph skill)"
fi

if [[ -t 0 ]] && [[ -f DESCRIPTION ]]; then
  read -r -p "Install optional post-commit Graphify hook for DESCRIPTION bumps? [y/N] " ans
  if [[ "${ans,,}" == "y" ]]; then
    HOOKS="${ROOT}/.git/hooks/post-commit"
    EX="${BUNDLE}/hooks/post-commit-graphify-milestone.example"
    mkdir -p "$(dirname "$HOOKS")"
    if [[ -f "$HOOKS" ]]; then
      grep -q graphify-milestone "$HOOKS" || cat "$EX" >> "$HOOKS"
    else
      cp "$EX" "$HOOKS"
    fi
    chmod +x "$HOOKS"
    echo "Installed $HOOKS"
  fi
fi