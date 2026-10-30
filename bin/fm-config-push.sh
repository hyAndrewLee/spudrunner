#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/config-push.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/config-push.sh" "$@"
fi
# shellcheck source=bin/config-push.sh
. "$(dirname "${BASH_SOURCE[0]}")/config-push.sh" "$@"
