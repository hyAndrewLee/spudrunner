#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/quota-choose.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/quota-choose.sh" "$@"
fi
# shellcheck source=bin/quota-choose.sh
. "$(dirname "${BASH_SOURCE[0]}")/quota-choose.sh" "$@"
