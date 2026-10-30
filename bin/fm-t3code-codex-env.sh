#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/t3code-codex-env.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/t3code-codex-env.sh" "$@"
fi
# shellcheck source=bin/t3code-codex-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/t3code-codex-env.sh" "$@"
