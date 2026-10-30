#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/gemini-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/gemini-lib.sh" "$@"
fi
# shellcheck source=bin/gemini-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/gemini-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_gemini_path_is_gemini() { gemini_path_is_gemini "$@"; }
fm_gemini_pid_is_gemini() { gemini_pid_is_gemini "$@"; }
fm_gemini_args_are_gemini() { gemini_args_are_gemini "$@"; }
