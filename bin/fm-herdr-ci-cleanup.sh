#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/herdr-ci-cleanup.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/herdr-ci-cleanup.sh" "$@"
fi
# shellcheck source=bin/herdr-ci-cleanup.sh
. "$(dirname "${BASH_SOURCE[0]}")/herdr-ci-cleanup.sh" "$@"
