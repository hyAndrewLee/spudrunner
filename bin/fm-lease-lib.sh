#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-lease-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-lease-lib.sh" "$@"
fi
# shellcheck source=bin/supervision-lease-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-lease-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_lease_lock_helpers() { supervision_lease_lock_helpers "$@"; }
fm_lease_tagged_holder_live() { supervision_lease_tagged_holder_live "$@"; }
fm_lease_home_runs_host() { supervision_lease_home_runs_host "$@"; }
fm_lease_actor() { supervision_lease_actor "$@"; }
fm_lease_valid_id() { supervision_lease_valid_id "$@"; }
fm_lease_path() { supervision_lease_path "$@"; }
fm_lease_read() { supervision_lease_read "$@"; }
fm_lease_live() { supervision_lease_live "$@"; }
fm_lease_rekey_holder() { supervision_lease_rekey_holder "$@"; }
fm_lease_clear_stale() { supervision_lease_clear_stale "$@"; }
fm_lease_guard() { supervision_lease_guard "$@"; }
fm_lease_guard_release() { supervision_lease_guard_release "$@"; }
fm_lease_away_relocated() { supervision_lease_away_relocated "$@"; }
fm_lease_forbid_branch() { supervision_lease_forbid_branch "$@"; }
