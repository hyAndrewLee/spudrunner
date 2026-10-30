#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-reviewers.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-reviewers.sh" "$@"
fi
# shellcheck source=bin/pr-reviewers.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-reviewers.sh" "$@"
