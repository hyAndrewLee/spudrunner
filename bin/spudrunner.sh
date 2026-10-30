#!/usr/bin/env bash
# spudrunner.sh - bunx/npx entrypoint; clone a persistent home, then run setup.
# Usage: spudrunner setup [--directory PATH] [--dry-run]
#        [--harnesses pi,claude,codex] [--backend tmux|herdr]
# Default directory: ~/spudrunner. Requires Bash and Git (no Node dependency).
# Clones only https://github.com/hyAndrewLee/spudrunner.git; never creates a fork.
# Reuses only that repository's existing checkout, without pulling or resetting.
# --dry-run prints the clone/setup commands without network access or writes.
set -eu

usage() { head -n 8 "$0" | tail -n +2 | cut -c3-; }
die() { printf 'spudrunner: %s\n' "$*" >&2; exit 1; }
case "${1:-}" in
  -h|--help|'') usage; exit 0 ;;
  setup) shift ;;
  *) die 'expected: spudrunner setup (or --help)' ;;
esac
DIRECTORY="$HOME/spudrunner"
ARGS=()
DRY_RUN=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --directory)
      [ "$#" -ge 2 ] && [ -n "$2" ] || die '--directory needs a path'
      DIRECTORY=$2; shift 2 ;;
    --backend|--harnesses)
      [ "$#" -ge 2 ] && [ -n "$2" ] || die "$1 needs a value"
      ARGS+=("$1" "$2"); shift 2 ;;
    --dry-run) DRY_RUN=1; ARGS+=("$1"); shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done
case "$DIRECTORY" in /*) ;; *) DIRECTORY="$PWD/$DIRECTORY" ;; esac
[ ! -L "$DIRECTORY" ] || die "refusing a symlink destination: $DIRECTORY"
REPO=https://github.com/hyAndrewLee/spudrunner.git
if [ -e "$DIRECTORY" ]; then
  [ -d "$DIRECTORY/.git" ] || [ -f "$DIRECTORY/.git" ] || die "destination is not a Git checkout: $DIRECTORY"
  origin=$(git -C "$DIRECTORY" remote get-url origin | tr '[:upper:]' '[:lower:]')
  case "$origin" in
    https://github.com/hyandrewlee/spudrunner.git|https://github.com/hyandrewlee/spudrunner|git@github.com:hyandrewlee/spudrunner.git|ssh://git@github.com/hyandrewlee/spudrunner.git) ;;
    *) die 'existing destination does not have your Spudrunner repository as origin' ;;
  esac
else
  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'git clone %q %q\n' "$REPO" "$DIRECTORY"
  else
    command -v git >/dev/null || die 'install Git first, then rerun this command'
    git clone "$REPO" "$DIRECTORY"
  fi
fi
if [ "$DRY_RUN" -eq 1 ]; then
  printf 'bash %q' "$DIRECTORY/bin/setup.sh"
  [ "${#ARGS[@]}" -eq 0 ] || printf ' %q' "${ARGS[@]}"
  printf '\n'
  exit 0
fi
[ -f "$DIRECTORY/bin/setup.sh" ] || die 'checkout has no bin/setup.sh; update it to a release containing the installer'
exec bash "$DIRECTORY/bin/setup.sh" ${ARGS[@]+"${ARGS[@]}"}
