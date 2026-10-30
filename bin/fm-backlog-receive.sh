#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/backlog-receive.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/backlog-receive.sh" "$@"
fi
# shellcheck source=bin/backlog-receive.sh
. "$(dirname "${BASH_SOURCE[0]}")/backlog-receive.sh" "$@"
