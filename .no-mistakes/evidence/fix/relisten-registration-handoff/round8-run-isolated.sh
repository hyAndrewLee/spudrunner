#!/usr/bin/env bash
set -eu
export PATH="/home/andrew/spudrunner-green/tools:/home/andrew/.nvm/versions/node/v22.23.3/bin:$PATH"
export TMPDIR=/tmp
exec 9</home/andrew/spudrunner-green/serial-tests.lock
flock -x -w 20 9
ulimit -v 4194304
ulimit -t 480
exec unshare --user --map-current-user --pid --fork --mount-proc "$@"
