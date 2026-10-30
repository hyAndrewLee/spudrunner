#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/relay-poll.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/relay-poll.sh" "$@"
fi
# shellcheck source=bin/relay-poll.sh
. "$(dirname "${BASH_SOURCE[0]}")/relay-poll.sh" "$@"
