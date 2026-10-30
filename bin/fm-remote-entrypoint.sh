#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-entrypoint.sh.
_FM_REMOTE_SOURCE=${BASH_SOURCE[0]}
while [ -L "$_FM_REMOTE_SOURCE" ]; do
  _FM_REMOTE_DIR=$(cd -P "$(dirname "$_FM_REMOTE_SOURCE")" && pwd) || exit 1
  _FM_REMOTE_SOURCE=$(readlink "$_FM_REMOTE_SOURCE") || exit 1
  case "$_FM_REMOTE_SOURCE" in
    /*) ;;
    *) _FM_REMOTE_SOURCE=$_FM_REMOTE_DIR/$_FM_REMOTE_SOURCE ;;
  esac
done
_FM_REMOTE_DIR=$(cd -P "$(dirname "$_FM_REMOTE_SOURCE")" && pwd) || exit 1
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$_FM_REMOTE_DIR/remote-entrypoint.sh" "$@"
fi
# shellcheck source=bin/remote-entrypoint.sh
. "$_FM_REMOTE_DIR/remote-entrypoint.sh" "$@"
