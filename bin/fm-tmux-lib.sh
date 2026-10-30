#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/tmux-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/tmux-lib.sh" "$@"
fi
# shellcheck source=bin/tmux-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/tmux-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_tmux_strip_ghost() { tmux_strip_ghost "$@"; }
fm_tmux_composer_capture() { tmux_composer_capture "$@"; }
fm_tmux_composer_cursor_row() { tmux_composer_cursor_row "$@"; }
fm_tmux_composer_caps() { tmux_composer_caps "$@"; }
fm_tmux_composer_identity() { tmux_composer_identity "$@"; }
fm_tmux_composer_state() { tmux_composer_state "$@"; }
fm_tmux_pane_is_cortex() { tmux_pane_is_cortex "$@"; }
fm_tmux_pane_is_cursor() { tmux_pane_is_cursor "$@"; }
fm_pane_input_pending() { pane_input_pending "$@"; }
fm_pane_busy_state() { pane_busy_state "$@"; }
fm_pane_is_busy() { pane_is_busy "$@"; }
fm_tmux_submit_enter_core() { tmux_submit_enter_core "$@"; }
fm_tmux_submit_busy_harness() { tmux_submit_busy_harness "$@"; }
fm_tmux_submit_core() { tmux_submit_core "$@"; }
