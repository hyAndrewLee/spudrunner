#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/digest-line-limit-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/digest-line-limit-lib.sh" "$@"
fi
# shellcheck source=bin/digest-line-limit-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/digest-line-limit-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_cap_line_var() { cap_line_var "$@"; }
fm_cap_line() { cap_line "$@"; }
