#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/lint.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/lint.sh" "$@"
fi
# shellcheck source=bin/lint.sh
. "$(dirname "${BASH_SOURCE[0]}")/lint.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_lint_worker_stop() { lint_worker_stop "$@"; }
fm_lint_now_ms() { lint_now_ms "$@"; }
fm_lint_signal_name() { lint_signal_name "$@"; }
fm_lint_root_rss() { lint_root_rss "$@"; }
fm_lint_max_root_rss() { lint_max_root_rss "$@"; }
fm_lint_classify_root() { lint_classify_root "$@"; }
fm_lint_exec_root() { lint_exec_root "$@"; }
fm_lint_run_root() { lint_run_root "$@"; }
fm_lint_worker() { lint_worker "$@"; }
fm_lint_usage() { lint_usage "$@"; }
fm_lint_run_workflows() { lint_run_workflows "$@"; }
fm_lint_run_backend_purity() { lint_run_backend_purity "$@"; }
fm_lint_changed_base_ref() { lint_changed_base_ref "$@"; }
fm_lint_is_canonical_root() { lint_is_canonical_root "$@"; }
fm_lint_root_weights() { lint_root_weights "$@"; }
fm_lint_cleanup() { lint_cleanup "$@"; }
fm_lint_shellcheck_count() { lint_shellcheck_count "$@"; }
fm_lint_load_average() { lint_load_average "$@"; }
fm_lint_aggregate_cpu() { lint_aggregate_cpu "$@"; }
fm_lint_run_worker() { lint_run_worker "$@"; }
fm_lint_start_worker() { lint_start_worker "$@"; }
fm_lint_wait_workers() { lint_wait_workers "$@"; }
