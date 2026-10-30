#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/live-lab.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/live-lab.sh" "$@"
fi
# shellcheck source=bin/live-lab.sh
. "$(dirname "${BASH_SOURCE[0]}")/live-lab.sh" "$@"
