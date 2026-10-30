#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/working-directory-pretool-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/working-directory-pretool-check.sh" "$@"
fi
# shellcheck source=bin/working-directory-pretool-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/working-directory-pretool-check.sh" "$@"
