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

MANIFEST=".agent-sync-manifest"
# Names deployed before manifests existed; pruned once if still present.
LEGACY_RULES="graphify teaching-material-repo scope-workspace"
LEGACY_SKILLS="convert-documents-to-markdown latex-modern-audit peer-review-assistant find-skills testing-data-visualizations quarto auto-animate-elements quarto-revealjs-fragment react-and-nextjs-data-visualization"

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

list_bundle_rules() {
  local f
  for f in "${BUNDLE_ROOT}/rules/"*.mdc; do
    [[ -f "${f}" ]] && basename "${f}" .mdc
  done
}

# prune_dir DIR KIND LEGACY NAMES... : delete entries this tool deployed before
# (manifest, or LEGACY when no manifest yet) that are no longer in NAMES, then
# record NAMES. KIND: mdc | md (rule files) or dir (skill folders). Entries the
# tool never deployed are left alone.
prune_dir() {
  local dir="$1" kind="$2" legacy="$3"
  shift 3
  local -A keep=()
  local n
  for n in "$@"; do keep["${n}"]=1; done
  local old
  if [[ -f "${dir}/${MANIFEST}" ]]; then
    old="$(cat "${dir}/${MANIFEST}")"
  else
    old="${legacy}"
  fi
  for n in ${old}; do
    [[ -n "${keep[${n}]:-}" ]] && continue
    case "${kind}" in
      dir)
        if [[ -d "${dir}/${n}" && ! -L "${dir}/${n}" ]]; then
          rm -rf "${dir:?}/${n}"
          log "prune: ${dir}/${n}/"
        fi ;;
      *)
        # rule files may be symlinks (~/.cursor/rules -> ~/.claude/rules)
        if [[ -e "${dir}/${n}.${kind}" || -L "${dir}/${n}.${kind}" ]]; then
          rm -f "${dir}/${n}.${kind}"
          log "prune: ${dir}/${n}.${kind}"
        fi ;;
    esac
  done
  printf '%s\n' "$@" > "${dir}/${MANIFEST}"
}

in_manifest() {
  [[ -f "$1/${MANIFEST}" ]] && grep -qxF "$2" "$1/${MANIFEST}"
}

install_rules() {
  mkdir -p "${CURSOR_RULES}" "${CLAUDE_RULES}"
  local name
  local -a names=()
  while IFS= read -r name; do
    names+=("${name}")
    cp -a "${BUNDLE_ROOT}/rules/${name}.mdc" "${CURSOR_RULES}/${name}.mdc"
    cp -a "${BUNDLE_ROOT}/rules/${name}.mdc" "${CLAUDE_RULES}/${name}.md"
  done < <(list_bundle_rules)
  prune_dir "${CURSOR_RULES}" mdc "${LEGACY_RULES}" "${names[@]}"
  prune_dir "${CLAUDE_RULES}" md "${LEGACY_RULES}" "${names[@]}"
}

install_skills() {
  mkdir -p "${CURSOR_SKILLS}" "${CLAUDE_SKILLS}"
  local name
  local -a names=()
  while IFS= read -r name; do
    [[ -n "${name}" ]] || continue
    if [[ -L "${BUNDLE_ROOT}/skills/${name}" ]]; then
      log "skip symlink skill in bundle: ${name}"
      continue
    fi
    names+=("${name}")
    # --delete: a bundle skill folder is fully owned by the bundle.
    rsync -a --delete --no-links --exclude '.git' --exclude '__pycache__' --exclude 'node_modules' \
      "${BUNDLE_ROOT}/skills/${name}/" "${CURSOR_SKILLS}/${name}/"
    rsync -a --delete --no-links --exclude '.git' --exclude '__pycache__' --exclude 'node_modules' \
      "${BUNDLE_ROOT}/skills/${name}/" "${CLAUDE_SKILLS}/${name}/"
  done < <(list_vendored_skills)
  prune_dir "${CURSOR_SKILLS}" dir "${LEGACY_SKILLS}" "${names[@]}"
  prune_dir "${CLAUDE_SKILLS}" dir "${LEGACY_SKILLS}" "${names[@]}"
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
    elif ! in_manifest "${CURSOR_RULES}" "${base%.mdc}" \
      && [[ " ${LEGACY_RULES} " != *" ${base%.mdc} "* ]]; then
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

cmd_verify() {
  local failures=0 name
  fail() { log "FAIL: $*"; failures=$((failures + 1)); }
  while IFS= read -r name; do
    cmp -s "${BUNDLE_ROOT}/rules/${name}.mdc" "${CURSOR_RULES}/${name}.mdc" \
      || fail "${CURSOR_RULES}/${name}.mdc missing or differs from bundle"
    cmp -s "${BUNDLE_ROOT}/rules/${name}.mdc" "${CLAUDE_RULES}/${name}.md" \
      || fail "${CLAUDE_RULES}/${name}.md missing or differs from bundle"
  done < <(list_bundle_rules)
  while IFS= read -r name; do
    [[ -L "${BUNDLE_ROOT}/skills/${name}" ]] && continue
    diff -rq --exclude __pycache__ --exclude .git --exclude node_modules --exclude "${MANIFEST}" \
      "${BUNDLE_ROOT}/skills/${name}" "${CLAUDE_SKILLS}/${name}" >/dev/null 2>&1 \
      || fail "${CLAUDE_SKILLS}/${name} missing or differs (run install-user)"
    diff -rq --exclude __pycache__ --exclude .git --exclude node_modules --exclude "${MANIFEST}" \
      "${BUNDLE_ROOT}/skills/${name}" "${CURSOR_SKILLS}/${name}" >/dev/null 2>&1 \
      || fail "${CURSOR_SKILLS}/${name} missing or differs (run install-user)"
  done < <(list_vendored_skills)
  local dir
  for dir in "${CURSOR_RULES}" "${CLAUDE_RULES}"; do
    for name in ${LEGACY_RULES}; do
      [[ -e "${dir}/${name}.mdc" || -e "${dir}/${name}.md" ]] && fail "stale rule ${dir}/${name}"
    done
  done
  for dir in "${CURSOR_SKILLS}" "${CLAUDE_SKILLS}"; do
    for name in ${LEGACY_SKILLS}; do
      [[ -d "${dir}/${name}" && ! -L "${dir}/${name}" ]] && fail "stale skill ${dir}/${name}"
    done
  done
  if [[ -d "${HOME}/.cursor/skills-cursor/data-visualisation" ]]; then
    fail "built-in skills-cursor/data-visualisation should not exist"
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

# AGENTS.md carries a fenced ```yaml block:
#   packs:
#     - <pack in agent-packs.yaml>
#   project_rules: copy | symlink
read_agents_yaml() {
  awk '/^```yaml/ {b=1; next} b && /^```/ {exit} b {print}' "$1" 2>/dev/null || true
}

# pack_rules PACK : rule names (no extension) listed by the pack.
pack_rules() {
  local pack="$1"
  local list
  list="$(awk -v p="  ${pack}:" '
    $0 == p {inpack=1; next}
    inpack && /^  [^ ]/ {exit}
    inpack && /^    rules:/ {
      if ($0 ~ /all/) {print "ALL"; exit}
      inrules=1; next
    }
    inpack && inrules && /^      - / {sub(/^      - /, ""); print; next}
    inpack && inrules && /^    [^ ]/ {inrules=0}
  ' "${PACKS_FILE}")"
  [[ -n "${list}" ]] || die "pack ${pack} not found in ${PACKS_FILE}"
  if [[ "${list}" == "ALL" ]]; then
    list_bundle_rules
  else
    printf '%s\n' "${list}" | sed 's/\.mdc$//'
  fi
}

cmd_install_project() {
  local root="${1:-.}"
  root="$(cd "${root}" && pwd)"
  local yaml mode packs
  yaml="$(read_agents_yaml "${root}/AGENTS.md")"
  mode="$(printf '%s\n' "${yaml}" | sed -n 's/^project_rules:[[:space:]]*//p')"
  mode="${mode:-symlink}"
  packs="$(printf '%s\n' "${yaml}" | awk '/^packs:/ {p=1; next} p && /^  - / {sub(/^  - /, ""); print; next} p && /^[^ ]/ {p=0}')"
  packs="${packs:-user-global}"
  if [[ "${mode}" == "symlink" ]]; then
    mkdir -p "${root}/.cursor"
    ln -sfn "$(realpath --relative-to="${root}/.cursor" "${BUNDLE_ROOT}/rules")" "${root}/.cursor/rules"
    ln -sfn "$(realpath --relative-to="${root}/.cursor" "${BUNDLE_ROOT}/skills")" "${root}/.cursor/skills"
    log "install-project: ${root}/.cursor symlinked to the bundle"
    return 0
  fi
  local cur="${root}/.cursor/rules" cla="${root}/.claude/rules"
  [[ -L "${cur}" ]] && die "${cur} is a symlink; remove it before copy mode"
  mkdir -p "${cur}" "${cla}"
  local -a names=()
  local pack name
  while IFS= read -r pack; do
    while IFS= read -r name; do
      [[ -n "${name}" ]] || continue
      [[ -f "${BUNDLE_ROOT}/rules/${name}.mdc" ]] || die "pack ${pack}: no rule ${name}"
      names+=("${name}")
    done < <(pack_rules "${pack}")
  done <<< "${packs}"
  mapfile -t names < <(printf '%s\n' "${names[@]}" | sort -u)
  for name in "${names[@]}"; do
    cp "${BUNDLE_ROOT}/rules/${name}.mdc" "${cur}/${name}.mdc"
    cp "${BUNDLE_ROOT}/rules/${name}.mdc" "${cla}/${name}.md"
  done
  prune_dir "${cur}" mdc "${LEGACY_RULES}" "${names[@]}"
  prune_dir "${cla}" md "${LEGACY_RULES}" "${names[@]}"
  # Project-only rules live in .cursor/rules; mirror them for Claude Code.
  local f base
  for f in "${cur}/"*.mdc; do
    base="$(basename "${f}" .mdc)"
    in_manifest "${cur}" "${base}" && continue
    cp "${f}" "${cla}/${base}.md"
    log "install-project: project rule ${base} mirrored to .claude/rules"
  done
  log "install-project: ${#names[@]} bundle rules copied into ${root} (packs: $(echo ${packs}))"
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
    # Re-deploy so the other tool's copy matches the edited one.
    cmd_install_user
  fi
}

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  install-user       Deploy bundle rules/skills to ~/.cursor and ~/.claude
  publish            Copy vendored home changes back into Config/.cursor
  verify             Smoke test (exit 1 on failure)
  install-project [ROOT]   Symlink ROOT/.cursor to the bundle, or copy the
                     AGENTS.md packs into ROOT/.cursor/rules and .claude/rules
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