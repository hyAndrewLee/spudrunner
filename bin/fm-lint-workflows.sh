#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/lint-workflows.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/lint-workflows.sh" "$@"
fi
# shellcheck source=bin/lint-workflows.sh
. "$(dirname "${BASH_SOURCE[0]}")/lint-workflows.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_lint_workflows_usage() { lint_workflows_usage "$@"; }
