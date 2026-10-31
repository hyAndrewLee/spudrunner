# Test phase environment recheck

Final unchanged HEAD: `6c05bca9362dc80e1ead7461d4eb348935e95c80`.
Baseline production runner: `e1846c7ba5c06a894673f7c7f85f9cc925b7f86b`.
No tracked changes, pipeline controls, lint, formatter, static analysis, publication, or full repository suite run.

## Environment repair

`unshare --user --map-current-user --pid --fork --mount-proc` is supported and supplies real PID-1 reparenting without root permission bypass. Docker is unavailable in this WSL distro. Initial `--map-root-user` attempt failed the existing read-only-directory retirement assertion because root bypassed its permissions; that attempt is retained as `process-events-pidns.log`, not counted as passing.

With current-user mapping the exact unchanged `bin/test-run.sh --jobs 1 --per-script-timeout-secs 600 tests/process-events.test.sh` passed (249381 ms). See `process-events-pidns-user.log`, including the orphan and descendant assertions. This repairs the environment rather than weakening tests.

`bin/test-run.sh --jobs 1 --per-script-timeout-secs 300 tests/remote-reply.test.sh` also passed unchanged (167514 ms), including plain/NUL handoff and ownership refusals: `remote-reply-pidns.log`.

All heavy runs acquired the existing `/home/andrew/spudrunner-green/serial-tests.lock` exclusively with `flock -x -w 20 9`, opened read-only (`9<...`) to avoid changing that external file. PATH prepended `/home/andrew/spudrunner-green/tools` and `/home/andrew/.nvm/versions/node/v22.23.3/bin`; TMPDIR=/tmp. Runs used a 4194304-KiB virtual-memory ceiling, CPU ceilings (480 seconds process suite, 300 remote suite, 90/100 external checks), and outer `timeout -k 10` limits (620, 320, 80/110 seconds respectively). Each used a separate user/PID/mount namespace; no global configuration changed.

## Active-poll timeout remains a blocker, not green

Exact existing lifecycle-runner segment:
`FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 10 80 unshare --user --map-current-user --pid --fork --mount-proc bash -x tests/extension-host-binding.test.sh`.
It reached the active poll marker and blocked at `register-extension ext-flow active-source --config-ref replacement`, exiting 124. See `external-active-poll-current.log`.

Copied bin into temporary worktree-local `.test-phase-recheck/base/bin`, substituted only process-events.sh from the baseline, and pointed a temporary copy of the same test at that runner. The same segment reached the same active poll and same register-extension call, again exiting 124: `external-active-poll-baseline.log`. This is direct evidence that the active-poll timeout predates the handoff repair. It is not a successful active-poll registration refusal check. No unrelated locking change was attempted. Action: parent must retain this baseline validation limitation and arrange a separately scoped diagnosis; do not approve a failing command or silently skip it.

The retained pre-poll barrier driver still passes in the isolated environment: `external-owner-pidns.log`. Both public registration replacements refuse the live external owner. This check does NOT replace the timed-out active-poll case.

## Superseded-floor external-owner refusal

A temporary evidence driver additionally injects a stale but syntactically valid expected registration identity `0:0` into the external runner at the existing DEBUG/FIFO launch-floor barrier. The real floor check returns superseded; the changed retry must refuse external adoption. The runner exited successfully, no external poll marker was created, the existing registration remained, and later public replacement/retirement succeeded. See `external-superseded-floor-valid-identity.log` and `external-superseded-driver.sh`. This is explicit fault injection to exercise refusal, not a claim that a public replacement can bypass the external-owner lock. An initial malformed identity injection failed validation before supersession; retained in `external-superseded-floor.log`, not counted as the refusal proof.

## Replay and cleanup

Original evidence is preserved. Additional replay drivers are `external-active-baseline-driver.sh` and `external-superseded-driver.sh`; copy them temporarily under tests/ for relative library resolution. The baseline driver requires the temporary copied bin tree described above. Remove replay copies afterward. All temporary test drivers and copied bin trees from this turn were removed from the worktree; no prepared dependencies were removed.

Overall: orphan environment resolved; targeted process-events and remote-reply scripts pass; the pre-existing active-poll timeout is still a non-green limitation. This report does not authorize a gate exception or an overall pipeline pass.
