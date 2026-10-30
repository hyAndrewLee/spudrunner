#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/t3code-answer.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/t3code-answer.sh" "$@"
fi
# shellcheck source=bin/t3code-answer.sh
. "$(dirname "${BASH_SOURCE[0]}")/t3code-answer.sh" "$@"
