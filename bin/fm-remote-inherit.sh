#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-inherit.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-inherit.sh" "$@"
fi
# shellcheck source=bin/remote-inherit.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-inherit.sh" "$@"
