#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/devin-config.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/devin-config.sh" "$@"
fi
# shellcheck source=bin/devin-config.sh
. "$(dirname "${BASH_SOURCE[0]}")/devin-config.sh" "$@"
