#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/merge-outcome-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/merge-outcome-lib.sh" "$@"
fi
# shellcheck source=bin/merge-outcome-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/merge-outcome-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_merge_outcome_report() { merge_outcome_report "$@"; }
