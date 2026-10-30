#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-file.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-file.sh" "$@"
fi
# shellcheck source=bin/remote-file.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-file.sh" "$@"
