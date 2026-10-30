#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/test-run.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/test-run.sh" "$@"
fi
# shellcheck source=bin/test-run.sh
. "$(dirname "${BASH_SOURCE[0]}")/test-run.sh" "$@"
