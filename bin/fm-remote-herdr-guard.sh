#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-herdr-guard.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-herdr-guard.sh" "$@"
fi
# shellcheck source=bin/remote-herdr-guard.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-herdr-guard.sh" "$@"
