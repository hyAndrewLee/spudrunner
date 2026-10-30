#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/git-push-guard.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/git-push-guard.sh" "$@"
fi
# shellcheck source=bin/git-push-guard.sh
. "$(dirname "${BASH_SOURCE[0]}")/git-push-guard.sh" "$@"
