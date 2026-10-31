#!/usr/bin/env bash
set -eu
exec 9</home/andrew/spudrunner-green/serial-tests.lock
flock -x -w 10 9
ulimit -t 600
ulimit -n 1024
export PATH=/home/andrew/.nvm/versions/node/v22.23.3/bin:/home/andrew/spudrunner-green/tools:$PATH
export FM_TEST_SKIP_ORPHAN_REAP=1
exec unshare --user --map-root-user --pid --fork --kill-child --mount-proc --mount bash -c '
mount --bind "$PWD/.validation-tmp" /tmp
mount --bind "$PWD/.validation-tmp/passwd" /etc/passwd
export TMPDIR=/tmp HOME="$PWD/.validation-tmp/account"
exec capsh --drop=all -- -c '\''exec python3 .validation-tmp/pid1.py "$@"'\'' -- "$@"
' -- "$@"
