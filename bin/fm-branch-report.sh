#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-branch-report.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-branch-report.sh" "$@"
fi
# shellcheck source=bin/supervision-branch-report.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-branch-report.sh" "$@"
