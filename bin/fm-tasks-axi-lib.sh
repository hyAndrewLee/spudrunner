#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/tasks-axi-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/tasks-axi-lib.sh" "$@"
fi
# shellcheck source=bin/tasks-axi-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/tasks-axi-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_tasks_axi_version_parts() { tasks_axi_version_parts "$@"; }
fm_tasks_axi_compatible() { tasks_axi_compatible "$@"; }
fm_tasks_axi_compatible_probe() { tasks_axi_compatible_probe "$@"; }
fm_tasks_axi_update_has_archive_body() { tasks_axi_update_has_archive_body "$@"; }
fm_tasks_axi_mv_has_multi_id() { tasks_axi_mv_has_multi_id "$@"; }
fm_tasks_axi_check_reason() { tasks_axi_check_reason "$@"; }
fm_tasks_axi_missing_capabilities() { tasks_axi_missing_capabilities "$@"; }
fm_tasks_axi_backend_from_toml() { tasks_axi_backend_from_toml "$@"; }
fm_tasks_axi_backend_resolve() { tasks_axi_backend_resolve "$@"; }
fm_tasks_axi_backend() { tasks_axi_backend "$@"; }
fm_backlog_backend_value() { backlog_backend_value "$@"; }
fm_backlog_backend_manual() { backlog_backend_manual "$@"; }
fm_tasks_axi_backend_available() { tasks_axi_backend_available "$@"; }
