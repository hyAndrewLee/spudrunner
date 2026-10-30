#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-origin-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-origin-lib.sh" "$@"
fi
# shellcheck source=bin/project-origin-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-origin-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_project_origin_safe() { project_origin_safe "$@"; }
