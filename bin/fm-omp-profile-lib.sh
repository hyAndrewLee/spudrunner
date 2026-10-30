#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/omp-profile-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/omp-profile-lib.sh" "$@"
fi
# shellcheck source=bin/omp-profile-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/omp-profile-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_omp_profile_read() { omp_profile_read "$@"; }
fm_omp_profile_select() { omp_profile_select "$@"; }
