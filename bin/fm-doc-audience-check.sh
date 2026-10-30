#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/doc-audience-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/doc-audience-check.sh" "$@"
fi
# shellcheck source=bin/doc-audience-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/doc-audience-check.sh" "$@"
