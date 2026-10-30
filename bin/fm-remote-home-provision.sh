#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-home-provision.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-home-provision.sh" "$@"
fi
# shellcheck source=bin/remote-home-provision.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-home-provision.sh" "$@"
