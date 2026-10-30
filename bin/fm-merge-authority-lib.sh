#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/merge-authority-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/merge-authority-lib.sh" "$@"
fi
# shellcheck source=bin/merge-authority-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/merge-authority-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_merge_authority_resolve() { merge_authority_resolve "$@"; }
fm_merge_authority_record_matches() { merge_authority_record_matches "$@"; }
fm_merge_authority_persist() { merge_authority_persist "$@"; }
fm_merge_authority_read() { merge_authority_read "$@"; }
fm_merge_authority_remove_if_matches() { merge_authority_remove_if_matches "$@"; }
