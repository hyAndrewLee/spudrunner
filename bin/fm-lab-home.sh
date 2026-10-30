#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/lab-home.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/lab-home.sh" "$@"
fi
# shellcheck source=bin/lab-home.sh
. "$(dirname "${BASH_SOURCE[0]}")/lab-home.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_lab_home_error() { lab_home_error "$@"; }
fm_lab_home_tmux_record() { lab_home_tmux_record "$@"; }
fm_lab_home_mode() { lab_home_mode "$@"; }
fm_lab_home_owner() { lab_home_owner "$@"; }
