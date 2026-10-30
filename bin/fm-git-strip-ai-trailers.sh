#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/git-strip-ai-trailers.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/git-strip-ai-trailers.sh" "$@"
fi
# shellcheck source=bin/git-strip-ai-trailers.sh
. "$(dirname "${BASH_SOURCE[0]}")/git-strip-ai-trailers.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_is_ai_attribution_line() { is_ai_attribution_line "$@"; }
