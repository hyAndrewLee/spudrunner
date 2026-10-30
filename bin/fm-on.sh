#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-command.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-command.sh" "$@"
fi
# shellcheck source=bin/remote-command.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-command.sh" "$@"
