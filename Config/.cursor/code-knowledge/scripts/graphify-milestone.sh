#!/usr/bin/env bash
# Rebuild or update Graphify at a release milestone (tag or DESCRIPTION bump).
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

REASON="${GRAPHIFY_MILESTONE_REASON:-manual}"
TAG=""
if git describe --tags --exact-match HEAD 2>/dev/null; then
  TAG="$(git describe --tags --exact-match HEAD 2>/dev/null || true)"
  REASON="tag:${TAG}"
fi

DESC_VER=""
if [[ -f DESCRIPTION ]]; then
  DESC_VER="$(sed -n 's/^Version: *//p' DESCRIPTION | head -1 | tr -d '[:space:]')"
  if [[ -n "$DESC_VER" ]] && [[ "$REASON" == "manual" ]]; then
    REASON="description:${DESC_VER}"
  fi
fi

if ! command -v graphify >/dev/null 2>&1; then
  echo "graphify: not on PATH; skip milestone (${REASON})" >&2
  exit 0
fi

GRAPH_JSON="graphify-out/graph.json"
mkdir -p graphify-out

if [[ -f "$GRAPH_JSON" ]]; then
  echo "graphify milestone: update (${REASON})"
  graphify update "$ROOT" 2>&1 | tail -20 || {
    echo "graphify update failed; run /graphify manually" >&2
    exit 1
  }
else
  echo "graphify milestone: no graphify-out/graph.json (${REASON})"
  echo "Running code-only update (AST); for docs/semantic corpus run /graphify in an agent." >&2
  graphify update "$ROOT" 2>&1 | tail -20 || {
    echo "graphify update failed; run /graphify manually" >&2
    exit 1
  }
fi

{
  echo "reason=${REASON}"
  echo "at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "tag=${TAG}"
  echo "description_version=${DESC_VER}"
} > graphify-out/.milestone

echo "Wrote graphify-out/.milestone (${REASON})"