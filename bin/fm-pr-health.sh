#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-health.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-health.sh" "$@"
fi
# shellcheck source=bin/pr-health.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-health.sh" "$@"
