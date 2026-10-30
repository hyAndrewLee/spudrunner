#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/review-diff.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/review-diff.sh" "$@"
fi
# shellcheck source=bin/review-diff.sh
. "$(dirname "${BASH_SOURCE[0]}")/review-diff.sh" "$@"
