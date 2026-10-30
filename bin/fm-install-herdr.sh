#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/install-herdr.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/install-herdr.sh" "$@"
fi
# shellcheck source=bin/install-herdr.sh
. "$(dirname "${BASH_SOURCE[0]}")/install-herdr.sh" "$@"
