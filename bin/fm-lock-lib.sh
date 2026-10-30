#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/git-lock-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/git-lock-lib.sh" "$@"
fi
# shellcheck source=bin/git-lock-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/git-lock-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_lock_log() { lock_log "$@"; }
fm_lock_path_mtime() { lock_path_mtime "$@"; }
fm_lock_lsof_holder() { lock_lsof_holder "$@"; }
fm_lock_has_live_holder() { lock_has_live_holder "$@"; }
fm_lock_age() { lock_age "$@"; }
fm_lock_is_provably_stale() { lock_is_provably_stale "$@"; }
