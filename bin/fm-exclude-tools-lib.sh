#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/worker-tool-exclusions-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/worker-tool-exclusions-lib.sh" "$@"
fi
# shellcheck source=bin/worker-tool-exclusions-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/worker-tool-exclusions-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_exclude_tools_names() { exclude_tools_names "$@"; }
fm_exclude_tools_check() { exclude_tools_check "$@"; }
