#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/parent-channel-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/parent-channel-lib.sh" "$@"
fi
# shellcheck source=bin/parent-channel-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/parent-channel-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
_fm_parent_channel_id_valid() { _parent_channel_id_valid "$@"; }
fm_parent_channel_home_id() { parent_channel_home_id "$@"; }
fm_parent_channel_destination() { parent_channel_destination "$@"; }
fm_parent_channel_outbound_status() { parent_channel_outbound_status "$@"; }
fm_parent_channel_clean_note() { parent_channel_clean_note "$@"; }
fm_parent_channel_append_once() { parent_channel_append_once "$@"; }
fm_parent_channel_report() { parent_channel_report "$@"; }
