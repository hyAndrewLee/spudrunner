#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/merge-local.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/merge-local.sh" "$@"
fi
# shellcheck source=bin/merge-local.sh
. "$(dirname "${BASH_SOURCE[0]}")/merge-local.sh" "$@"
