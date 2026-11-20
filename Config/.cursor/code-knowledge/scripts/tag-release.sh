#!/usr/bin/env bash
# Create an annotated git tag and run graphify-milestone.sh
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <tag> [git tag args...]" >&2
  echo "Example: $0 v1.2.0 -m 'Release 1.2.0'" >&2
  exit 1
fi

TAG="$1"
shift

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

git tag -a "$TAG" "$@"
GRAPHIFY_MILESTONE_REASON="tag:${TAG}" \
  "${ROOT}/Config/.cursor/code-knowledge/scripts/graphify-milestone.sh"