#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/investigation-implement.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/investigation-implement.sh" "$@"
fi
# shellcheck source=bin/investigation-implement.sh
. "$(dirname "${BASH_SOURCE[0]}")/investigation-implement.sh" "$@"
