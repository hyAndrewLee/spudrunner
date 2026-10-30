#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-inherit-push.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-inherit-push.sh" "$@"
fi
# shellcheck source=bin/remote-inherit-push.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-inherit-push.sh" "$@"
