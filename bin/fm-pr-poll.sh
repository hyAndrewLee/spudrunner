#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-poll.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-poll.sh" "$@"
fi
# shellcheck source=bin/pr-poll.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-poll.sh" "$@"
