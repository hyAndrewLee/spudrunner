#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/install-shellcheck.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/install-shellcheck.sh" "$@"
fi
# shellcheck source=bin/install-shellcheck.sh
. "$(dirname "${BASH_SOURCE[0]}")/install-shellcheck.sh" "$@"
