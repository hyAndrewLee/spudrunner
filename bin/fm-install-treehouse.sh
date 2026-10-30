#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/install-treehouse.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/install-treehouse.sh" "$@"
fi
# shellcheck source=bin/install-treehouse.sh
. "$(dirname "${BASH_SOURCE[0]}")/install-treehouse.sh" "$@"
