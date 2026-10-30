#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/herdr-session-cleanup.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/herdr-session-cleanup.sh" "$@"
fi
# shellcheck source=bin/herdr-session-cleanup.sh
. "$(dirname "${BASH_SOURCE[0]}")/herdr-session-cleanup.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_herdr_cleanup_warn() { herdr_cleanup_warn "$@"; }
fm_herdr_cleanup_title_token() { herdr_cleanup_title_token "$@"; }
fm_herdr_cleanup_home_identity() { herdr_cleanup_home_identity "$@"; }
fm_herdr_cleanup_journal_matches() { herdr_cleanup_journal_matches "$@"; }
fm_herdr_cleanup_unique_match() { herdr_cleanup_unique_match "$@"; }
fm_herdr_cleanup_snapshot_candidate() { herdr_cleanup_snapshot_candidate "$@"; }
fm_herdr_cleanup_revalidate() { herdr_cleanup_revalidate "$@"; }
fm_herdr_cleanup_one() { herdr_cleanup_one "$@"; }
fm_herdr_session_cleanup() { herdr_session_cleanup "$@"; }
