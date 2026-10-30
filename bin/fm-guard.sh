#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-health.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-health.sh" "$@"
fi
# shellcheck source=bin/supervision-health.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-health.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_guard_stale_episode_key() { guard_stale_episode_key "$@"; }
fm_guard_claim_stale_banner() { guard_claim_stale_banner "$@"; }
fm_guard_stale_banner_seen() { guard_stale_banner_seen "$@"; }
fm_guard_clear_stale_banner() { guard_clear_stale_banner "$@"; }
