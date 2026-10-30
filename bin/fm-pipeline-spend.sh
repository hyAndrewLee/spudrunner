#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pipeline-spend.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pipeline-spend.sh" "$@"
fi
# shellcheck source=bin/pipeline-spend.sh
. "$(dirname "${BASH_SOURCE[0]}")/pipeline-spend.sh" "$@"
