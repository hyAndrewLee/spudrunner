#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/install-actionlint.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/install-actionlint.sh" "$@"
fi
# shellcheck source=bin/install-actionlint.sh
. "$(dirname "${BASH_SOURCE[0]}")/install-actionlint.sh" "$@"
