#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/cursor-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/cursor-lib.sh" "$@"
fi
# shellcheck source=bin/cursor-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/cursor-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_cursor_run_timed() { cursor_run_timed "$@"; }
fm_cursor_canonical_path() { cursor_canonical_path "$@"; }
fm_cursor_path_is_cursor() { cursor_path_is_cursor "$@"; }
fm_cursor_bounded_output() { cursor_bounded_output "$@"; }
fm_cursor_help_marks_cursor() { cursor_help_marks_cursor "$@"; }
fm_cursor_help_is_ide_shim_refusal() { cursor_help_is_ide_shim_refusal "$@"; }
fm_cursor_verify_executable() { cursor_verify_executable "$@"; }
fm_cursor_list_models() { cursor_list_models "$@"; }
fm_cursor_catalog_has_model() { cursor_catalog_has_model "$@"; }
fm_cursor_resolve_binary() { cursor_resolve_binary "$@"; }
fm_cursor_argv0_for_pid() { cursor_argv0_for_pid "$@"; }
fm_cursor_argv0_is_cursor() { cursor_argv0_is_cursor "$@"; }
fm_cursor_process_matches() { cursor_process_matches "$@"; }
