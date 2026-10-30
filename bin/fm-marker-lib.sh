#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/marker-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/marker-lib.sh" "$@"
fi
# shellcheck source=bin/marker-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/marker-lib.sh" "$@"
