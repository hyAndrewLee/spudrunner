#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-delta-read.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-delta-read.sh" "$@"
fi
# shellcheck source=bin/remote-delta-read.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-delta-read.sh" "$@"
