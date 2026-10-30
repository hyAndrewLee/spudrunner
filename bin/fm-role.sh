#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/publication-authority.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/publication-authority.sh" "$@"
fi
# shellcheck source=bin/publication-authority.sh
. "$(dirname "${BASH_SOURCE[0]}")/publication-authority.sh" "$@"
