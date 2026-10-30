#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/relay-dismiss.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/relay-dismiss.sh" "$@"
fi
# shellcheck source=bin/relay-dismiss.sh
. "$(dirname "${BASH_SOURCE[0]}")/relay-dismiss.sh" "$@"
