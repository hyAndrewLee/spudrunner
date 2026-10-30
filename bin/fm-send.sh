#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-steer.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-steer.sh" "$@"
fi
# shellcheck source=bin/task-steer.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-steer.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_send_id_from_meta() { send_id_from_meta "$@"; }
fm_send_clear_after_interrupt() { send_clear_after_interrupt "$@"; }
fm_send_normalize_key() { send_normalize_key "$@"; }
fm_send_record_interrupt() { send_record_interrupt "$@"; }
fm_send_meta_for_key_value() { send_meta_for_key_value "$@"; }
fm_send_count_colons() { send_count_colons "$@"; }
fm_send_resolve_target() { send_resolve_target "$@"; }
fm_send_add_resolve_key() { send_add_resolve_key "$@"; }
fm_send_known_undelivered_cleanup() { send_known_undelivered_cleanup "$@"; }
fm_send_hold_resolved_id() { send_hold_resolved_id "$@"; }
fm_send_resolve_close_note() { send_resolve_close_note "$@"; }
fm_send_close_resolved_keys() { send_close_resolved_keys "$@"; }
fm_send_feed_resolved_holds() { send_feed_resolved_holds "$@"; }
