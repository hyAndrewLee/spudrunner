#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/warm-compact-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/warm-compact-lib.sh" "$@"
fi
# shellcheck source=bin/warm-compact-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/warm-compact-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_warm_compact_config() { warm_compact_config "$@"; }
fm_warm_compact_context_tokens() { warm_compact_context_tokens "$@"; }
fm_warm_compact_verdict() { warm_compact_verdict "$@"; }
fm_warm_compact_primary() { warm_compact_primary "$@"; }
fm_warm_compact_engine_transcript() { warm_compact_engine_transcript "$@"; }
fm_warm_compact_engine() { warm_compact_engine "$@"; }
