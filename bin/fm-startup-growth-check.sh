#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/startup-growth-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/startup-growth-check.sh" "$@"
fi
# shellcheck source=bin/startup-growth-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/startup-growth-check.sh" "$@"
