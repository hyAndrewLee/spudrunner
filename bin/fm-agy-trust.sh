#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agy-trust.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agy-trust.sh" "$@"
fi
# shellcheck source=bin/agy-trust.sh
. "$(dirname "${BASH_SOURCE[0]}")/agy-trust.sh" "$@"
