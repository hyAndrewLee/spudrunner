#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/inbox.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/inbox.sh" "$@"
fi
# shellcheck source=bin/inbox.sh
. "$(dirname "${BASH_SOURCE[0]}")/inbox.sh" "$@"
