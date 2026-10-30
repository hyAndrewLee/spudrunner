#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/away-mode-return.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/away-mode-return.sh" "$@"
fi
# shellcheck source=bin/away-mode-return.sh
. "$(dirname "${BASH_SOURCE[0]}")/away-mode-return.sh" "$@"
