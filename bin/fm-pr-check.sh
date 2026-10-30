#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-check.sh" "$@"
fi
# shellcheck source=bin/pr-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-check.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_pr_check_ready_line_waits_for_green() { pr_check_ready_line_waits_for_green "$@"; }
