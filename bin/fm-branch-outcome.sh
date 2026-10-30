#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-branch-outcome.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-branch-outcome.sh" "$@"
fi
# shellcheck source=bin/supervision-branch-outcome.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-branch-outcome.sh" "$@"
