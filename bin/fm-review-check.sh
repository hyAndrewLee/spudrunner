#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/review-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/review-check.sh" "$@"
fi
# shellcheck source=bin/review-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/review-check.sh" "$@"
