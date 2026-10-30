#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/memory-curation-cascade.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/memory-curation-cascade.sh" "$@"
fi
# shellcheck source=bin/memory-curation-cascade.sh
. "$(dirname "${BASH_SOURCE[0]}")/memory-curation-cascade.sh" "$@"
