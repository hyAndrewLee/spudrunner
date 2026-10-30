#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/claude-stop-autoarm.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/claude-stop-autoarm.sh" "$@"
fi
# shellcheck source=bin/claude-stop-autoarm.sh
. "$(dirname "${BASH_SOURCE[0]}")/claude-stop-autoarm.sh" "$@"
