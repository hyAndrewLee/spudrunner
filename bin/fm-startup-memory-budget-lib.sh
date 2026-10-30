#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/startup-memory-budget-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/startup-memory-budget-lib.sh" "$@"
fi
# shellcheck source=bin/startup-memory-budget-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/startup-memory-budget-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_startup_memory_budget_fail() { startup_memory_budget_fail "$@"; }
fm_startup_memory_budget_link_count() { startup_memory_budget_link_count "$@"; }
fm_startup_memory_budget_config_dir_safe() { startup_memory_budget_config_dir_safe "$@"; }
fm_startup_memory_budget_file_valid() { startup_memory_budget_file_valid "$@"; }
fm_startup_memory_budget_read() { startup_memory_budget_read "$@"; }
fm_startup_memory_budget_materialize() { startup_memory_budget_materialize "$@"; }
fm_startup_memory_estimated_tokens_for_bytes() { startup_memory_estimated_tokens_for_bytes "$@"; }
fm_startup_memory_measure_file() { startup_memory_measure_file "$@"; }
fm_startup_memory_decimal_le() { startup_memory_decimal_le "$@"; }
