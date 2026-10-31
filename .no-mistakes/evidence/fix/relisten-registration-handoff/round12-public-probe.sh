#!/usr/bin/env bash
set -euo pipefail
root=$1
scratch=$(mktemp -d /tmp/control-path-probe.XXXXXX)
trap 'rm -rf -- "$scratch"' EXIT
export FM_HOME="$scratch/home" FM_PROCEVENT_CLAIM_ROOT="$scratch/claims"
mkdir -m 700 "$FM_HOME"
printf 'uid=%s gid=%s pid=%s\n' "$(id -u)" "$(id -g)" "$$"
for kind in tab newline; do
  case "$kind" in tab) state="$scratch/state"$'\t'"tab" ;; newline) state="$scratch/state"$'\n'"newline" ;; esac
  mkdir -m 700 "$state"
  printf 'decoy\n' > "$state/decoy"
  before=$(sha256sum "$state/decoy")
  stat_before=$(stat -c '%d:%i:%a:%u' "$state")
  id="control-$kind-state-source"
  export FM_STATE_OVERRIDE="$state"
  set +e
  output=$(bash "$root/bin/process-events.sh" register lavish "$id" -- /bin/sh -c 'touch "$1"; printf "control\n"' sh "$scratch/polled" 2>&1)
  rc=$?
  set -e
  printf '%s register rc=%s output=%q\n' "$kind" "$rc" "$output"
  if [ "$kind" = newline ]; then
    [ "$rc" -eq 1 ] && [ "$output" = 'error: process-event state root is not a private directory' ]
    [ ! -e "$state/procevent/$id.source" ]
  else
    [ "$rc" -eq 0 ]
    source_before=$(sha256sum "$state/procevent/$id.source")
    set +e
    output=$(bash "$root/bin/process-events.sh" start "$id" 2>&1)
    rc=$?
    set -e
    printf '%s start rc=%s output=%q\n' "$kind" "$rc" "$output"
    [ "$rc" -eq 1 ] && [ "$output" = "error: cannot claim source: $id" ]
    [ "$source_before" = "$(sha256sum "$state/procevent/$id.source")" ]
    printf 'source byte hash: %s\n' "$source_before"
  fi
  [ "$before" = "$(sha256sum "$state/decoy")" ]
  [ "$stat_before" = "$(stat -c '%d:%i:%a:%u' "$state")" ]
  [ ! -e "$FM_PROCEVENT_CLAIM_ROOT/$id.claim" ]
  [ ! -e "$state/procevent-capture-reservations" ]
  [ ! -e "$state/procevent-inbox/$id.1.result" ]
  [ ! -e "$scratch/polled" ]
  printf 'decoy byte hash: %s; directory: %s; no claim/reservation/capture/poll\n' "$before" "$stat_before"
  # Supporting mechanism probe only; public refusal above is decisive evidence.
  bash -c '. "$1/bin/process-events-lib.sh"; actual=$(CDPATH="" cd -P -- "$2" && pwd -P); normalized=$(process_events_path_normalize "$2"); printf "canonical=%q normalized=%q\n" "$actual" "$normalized"; if [ "$3" = newline ]; then [ "$actual" != "$normalized" ]; else [ "$actual" = "$normalized" ]; fi' _ "$root" "$state" "$kind"
done
