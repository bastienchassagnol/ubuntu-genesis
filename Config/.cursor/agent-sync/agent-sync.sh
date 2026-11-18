#!/usr/bin/env bash
# Deploy rules/skills from Config/.cursor (git) to ~/.cursor and ~/.claude.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLE_ROOT="${AGENT_BUNDLE_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
PACKS_FILE="${SCRIPT_DIR}/agent-packs.yaml"
LOCK_FILE="${TMPDIR:-/tmp}/agent-sync-${USER}.lock"

CURSOR_RULES="${HOME}/.cursor/rules"
CURSOR_SKILLS="${HOME}/.cursor/skills"
CLAUDE_RULES="${HOME}/.claude/rules"
CLAUDE_SKILLS="${HOME}/.claude/skills"

log() { printf 'agent-sync: %s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

acquire_lock() {
  exec 9>"${LOCK_FILE}"
  if ! flock -n 9; then
    log "another agent-sync is running; skip"
    exit 0
  fi
}

skill_excluded() {
  local name="$1"
  case "${name}" in
    firecrawl*) return 0 ;;
  esac
  return 1
}

list_vendored_skills() {
  local d
  for d in "${BUNDLE_ROOT}/skills"/*; do
    [[ -d "${d}" ]] || continue
    local base
    base="$(basename "${d}")"
    skill_excluded "${base}" && continue
    printf '%s\n' "${base}"
  done
}

install_rules() {
  mkdir -p "${CURSOR_RULES}" "${CLAUDE_RULES}"
  local f base
  for f in "${BUNDLE_ROOT}/rules/"*.mdc; do
    [[ -f "${f}" ]] || continue
    base="$(basename "${f}")"
    cp -a "${f}" "${CURSOR_RULES}/${base}"
    cp -a "${f}" "${CLAUDE_RULES}/${base%.mdc}.md"
  done
}

install_skills() {
  mkdir -p "${CURSOR_SKILLS}" "${CLAUDE_SKILLS}"
  local name
  while IFS= read -r name; do
    [[ -n "${name}" ]] || continue
    if [[ -L "${BUNDLE_ROOT}/skills/${name}" ]]; then
      log "skip symlink skill in bundle: ${name}"
      continue
    fi
    rsync -a --no-links --exclude '.git' --exclude '__pycache__' --exclude 'node_modules' \
      "${BUNDLE_ROOT}/skills/${name}/" "${CURSOR_SKILLS}/${name}/"
    rsync -a --no-links --exclude '.git' --exclude '__pycache__' --exclude 'node_modules' \
      "${BUNDLE_ROOT}/skills/${name}/" "${CLAUDE_SKILLS}/${name}/"
  done < <(list_vendored_skills)
}

cmd_install_user() {
  acquire_lock
  [[ -d "${BUNDLE_ROOT}/rules" ]] || die "missing ${BUNDLE_ROOT}/rules"
  install_rules
  install_skills
  log "install-user: deployed rules and vendored skills from ${BUNDLE_ROOT}"
}

# Publish home changes back into the bundle (does not git commit).
cmd_publish() {
  local changed=0
  mkdir -p "${BUNDLE_ROOT}/rules"
  local f base
  for f in "${CURSOR_RULES}/"*.mdc; do
    [[ -f "${f}" ]] || continue
    base="$(basename "${f}")"
    if [[ -f "${BUNDLE_ROOT}/rules/${base}" ]]; then
      if ! cmp -s "${f}" "${BUNDLE_ROOT}/rules/${base}"; then
        cp -a "${f}" "${BUNDLE_ROOT}/rules/${base}"
        log "publish: ${base} (cursor → bundle)"
        changed=$((changed + 1))
      fi
    else
      cp -a "${f}" "${BUNDLE_ROOT}/rules/${base}"
      log "publish: new rule ${base}"
      changed=$((changed + 1))
    fi
  done
  for f in "${CLAUDE_RULES}/"*.md; do
    [[ -f "${f}" ]] || continue
    base="$(basename "${f}" .md).mdc"
    if [[ -f "${BUNDLE_ROOT}/rules/${base}" ]]; then
      if ! cmp -s "${f}" "${BUNDLE_ROOT}/rules/${base}"; then
        cp -a "${f}" "${BUNDLE_ROOT}/rules/${base}"
        log "publish: ${base} (claude → bundle)"
        changed=$((changed + 1))
      fi
    fi
  done
  local name
  while IFS= read -r name; do
    [[ -n "${name}" ]] || continue
    [[ -d "${CLAUDE_SKILLS}/${name}" ]] || continue
    [[ -L "${CLAUDE_SKILLS}/${name}" ]] && continue
    if diff -qr "${CLAUDE_SKILLS}/${name}" "${BUNDLE_ROOT}/skills/${name}" \
      >/dev/null 2>&1; then
      continue
    fi
    rsync -a --no-links --exclude '.git' --exclude '__pycache__' \
      "${CLAUDE_SKILLS}/${name}/" "${BUNDLE_ROOT}/skills/${name}/"
    log "publish: skill ${name} (claude → bundle)"
    changed=$((changed + 1))
  done < <(list_vendored_skills)
  if [[ "${changed}" -eq 0 ]]; then
    log "publish: bundle already matches home (vendored paths)"
  else
    log "publish: ${changed} update(s) — review git diff under Config/.cursor and commit"
  fi
}

rule_body_match() {
  local cursor_file="$1"
  local bundle_file="$2"
  cmp -s "${cursor_file}" "${bundle_file}"
}

cmd_verify() {
  local failures=0
  [[ -f "${BUNDLE_ROOT}/rules/scope-workspace.mdc" ]] || {
    log "FAIL: bundle scope-workspace.mdc missing"
    failures=$((failures + 1))
  }
  if [[ -f "${BUNDLE_ROOT}/rules/scope-workspace.mdc" ]]; then
    if [[ ! -f "${CURSOR_RULES}/scope-workspace.mdc" ]]; then
      log "FAIL: missing ${CURSOR_RULES}/scope-workspace.mdc"
      failures=$((failures + 1))
    elif ! rule_body_match "${CURSOR_RULES}/scope-workspace.mdc" \
      "${BUNDLE_ROOT}/rules/scope-workspace.mdc"; then
      log "FAIL: cursor rule scope-workspace.mdc differs from bundle"
      failures=$((failures + 1))
    fi
    if [[ ! -f "${CLAUDE_RULES}/scope-workspace.md" ]]; then
      log "FAIL: missing ${CLAUDE_RULES}/scope-workspace.md"
      failures=$((failures + 1))
    elif ! rule_body_match "${CLAUDE_RULES}/scope-workspace.md" \
      "${BUNDLE_ROOT}/rules/scope-workspace.mdc"; then
      log "FAIL: claude rule scope-workspace.md differs from bundle"
      failures=$((failures + 1))
    fi
  fi
  for ref in chart-chooser.md; do
    if [[ ! -f "${CLAUDE_SKILLS}/data-visualisation/references/${ref}" ]]; then
      log "FAIL: missing ${CLAUDE_SKILLS}/data-visualisation/references/${ref}"
      failures=$((failures + 1))
    fi
    if [[ ! -f "${CURSOR_SKILLS}/data-visualisation/references/${ref}" ]]; then
      log "FAIL: missing ${CURSOR_SKILLS}/data-visualisation/references/${ref}"
      failures=$((failures + 1))
    fi
  done
  if [[ -d "${HOME}/.cursor/skills-cursor/data-visualisation" ]]; then
    log "FAIL: built-in skills-cursor/data-visualisation should not exist"
    failures=$((failures + 1))
  fi
  local proj_root="${AGENT_PROJECT_ROOT:-}"
  if [[ -z "${proj_root}" ]] && command -v git >/dev/null 2>&1; then
    proj_root="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel 2>/dev/null || true)"
  fi
  if [[ -n "${proj_root}" && -L "${proj_root}/.cursor/rules" ]]; then
    local target
    target="$(readlink -f "${proj_root}/.cursor/rules" || true)"
    if [[ "${target}" != *"Config/.cursor/rules" ]]; then
      log "WARN: .cursor/rules -> ${target} (expected Config/.cursor/rules)"
    else
      log "OK: project .cursor/rules symlink"
    fi
  fi
  if [[ "${failures}" -gt 0 ]]; then
    log "verify: ${failures} failure(s)"
    exit 1
  fi
  log "verify: OK"
}

read_agents_packs() {
  # Prints one pack name per line from AGENTS.md fenced yaml block.
  local agents_md="$1"
  [[ -f "${agents_md}" ]] || return 0
  awk '
    /^```yaml/ {inblock=1; next}
    inblock && /^```/ {exit}
    inblock && /^[[:space:]]*-[[:space:]]+/ {
      gsub(/^[[:space:]]*-[[:space:]]*/, ""); print
    }
    inblock && /^packs:/ {getline; if ($0 ~ /^[[:space:]]*-[[:space:]]+/) {
      gsub(/^[[:space:]]*-[[:space:]]*/, ""); print
    }}
  ' "${agents_md}" 2>/dev/null || true
}

cmd_install_project() {
  local root="${1:-.}"
  root="$(cd "${root}" && pwd)"
  local agents="${root}/AGENTS.md"
  local mode="symlink"
  if grep -q 'rules: copy' "${agents}" 2>/dev/null; then
    mode="copy"
  fi
  mkdir -p "${root}/.cursor"
  local packs
  packs="$(read_agents_packs "${agents}")"
  if [[ -z "${packs}" ]]; then
    packs="user-global"
  fi
  if [[ "${packs}" == *"user-global"* ]] || [[ -z "$(read_agents_packs "${agents}")" ]]; then
    if [[ "${mode}" == "symlink" ]]; then
      local rel_rules rel_skills
      rel_rules="$(realpath --relative-to="${root}/.cursor" "${BUNDLE_ROOT}/rules" 2>/dev/null || true)"
      rel_skills="$(realpath --relative-to="${root}/.cursor" "${BUNDLE_ROOT}/skills" 2>/dev/null || true)"
      if [[ -n "${rel_rules}" ]]; then
        ln -sfn "${rel_rules}" "${root}/.cursor/rules"
      else
        ln -sfn "${BUNDLE_ROOT}/rules" "${root}/.cursor/rules"
      fi
      if [[ -n "${rel_skills}" ]]; then
        ln -sfn "${rel_skills}" "${root}/.cursor/skills"
      else
        ln -sfn "${BUNDLE_ROOT}/skills" "${root}/.cursor/skills"
      fi
    else
      rsync -a "${BUNDLE_ROOT}/rules/" "${root}/.cursor/rules/"
      local name
      while IFS= read -r name; do
        [[ -n "${name}" ]] || continue
        rsync -a "${BUNDLE_ROOT}/skills/${name}/" "${root}/.cursor/skills/${name}/"
      done < <(list_vendored_skills)
    fi
    log "install-project: ${root}/.cursor → bundle (${mode})"
    return 0
  fi
  log "install-project: custom pack lists not fully implemented; use user-global in AGENTS.md"
  exit 1
}

cmd_install_remote() {
  local host="${AGENT_SYNC_HOST:-}"
  [[ -n "${host}" ]] || die "set AGENT_SYNC_HOST=user@cluster"
  local repo_path="${AGENT_REMOTE_REPO:-\$HOME/repos/ubuntu-genesis}"
  ssh "${host}" "set -euo pipefail; cd ${repo_path}; git pull --ff-only; AGENT_BUNDLE_ROOT=${repo_path}/Config/.cursor ./Config/.cursor/agent-sync/agent-sync.sh install-user; ./Config/.cursor/agent-sync/agent-sync.sh verify"
}

cmd_after_edit() {
  local path="${1:-}"
  [[ -n "${path}" ]] || exit 0
  if [[ "${path}" == *"/Config/.cursor/"* ]]; then
    cmd_install_user
  elif [[ "${path}" == "${CURSOR_RULES}/"* ]] || [[ "${path}" == "${CURSOR_SKILLS}/"* ]] \
    || [[ "${path}" == "${CLAUDE_RULES}/"* ]] || [[ "${path}" == "${CLAUDE_SKILLS}/"* ]]; then
    cmd_publish
  fi
}

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  install-user       Deploy bundle rules/skills to ~/.cursor and ~/.claude
  publish            Copy vendored home changes back into Config/.cursor
  verify             Smoke test (exit 1 on failure)
  install-project [ROOT]   Link or copy bundle into ROOT/.cursor
  install-remote     ssh AGENT_SYNC_HOST, git pull, install-user, verify
  after-edit PATH    Hook helper: install-user or publish by path

Environment:
  AGENT_BUNDLE_ROOT   Path to Config/.cursor (default: parent of agent-sync/)
  AGENT_SYNC_HOST     user@host for install-remote
  AGENT_REMOTE_REPO   Remote path to ubuntu-genesis (default: ~/repos/ubuntu-genesis)
  AGENT_PROJECT_ROOT  Repo root for verify symlink check
EOF
}

main() {
  local cmd="${1:-}"
  shift || true
  case "${cmd}" in
    install-user) cmd_install_user "$@" ;;
    publish) cmd_publish "$@" ;;
    verify) cmd_verify "$@" ;;
    install-project) cmd_install_project "$@" ;;
    install-remote) cmd_install_remote "$@" ;;
    after-edit) cmd_after_edit "$@" ;;
    -h | --help | help) usage ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"