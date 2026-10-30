#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/worktree-isolation-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/worktree-isolation-lib.sh" "$@"
fi
# shellcheck source=bin/worktree-isolation-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/worktree-isolation-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_default_branch() { default_branch "$@"; }
fm_primary_tangle_branch() { primary_tangle_branch "$@"; }
