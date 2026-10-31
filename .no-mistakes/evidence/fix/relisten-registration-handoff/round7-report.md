# Targeted live Test result: existing blocker reproduced

Final SHA: `6c05bca9362dc80e1ead7461d4eb348935e95c80`. No tracked edits; transient fixtures and drivers removed. All earlier evidence preserved.

## Isolation and exact execution

Reused the preserved round5 supported user/PID/mount namespace wrapper and PID-1 reaper. Account, HOME, namespace /tmp backing, and archived baseline were created only under `.validation-tmp` in this worktree. Namespace-only /etc/passwd and /tmp bind mounts did not alter host files. Dropped capabilities before running product/tests. Pinned PATH prefixes: `/home/andrew/.nvm/versions/node/v22.23.3/bin:/home/andrew/spudrunner-green/tools`; shell `/usr/bin/bash`. Each run independently held exclusive `flock -x -w 10` on read-open `/home/andrew/spudrunner-green/serial-tests.lock`; CPU limit 600s and descriptor limit 1024. `FM_TEST_SKIP_ORPHAN_REAP=1` suppresses only the shared stale-fixture cleanup scan, not orphan assertions. No assertion was skipped or changed.

Commands below use `W=/usr/bin/bash .validation-tmp/run-isolated.sh`, not an actual shell variable containing arguments. Retained wrapper and reaper: `round7-run-isolated.sh`, `round7-pid1.py`.

- `timeout -k 10 360 W /usr/bin/bash tests/round7-remote-evidence-driver.sh`: exit 0. The tracked remote-reply end-to-end test with only product-record capture additions, inherited from round5 and renamed evidence outputs. Real public registration, handler, runner, entrypoint and delta reader; local SSH transport shim, no real network or hosted-failure attribution. Barrier replaces inode exactly after adoption/before floor check. Same PID/token consumes next plain and NUL payloads without fallback/reconcile. Control normalization, digest and cursor assertions retained. All seven invalid-adoption cases passed. Product records retained in round7-handoff-product-records.log and round7-refusal-product-records.log.
- `timeout -k 10 650 W /usr/bin/bash tests/process-events.test.sh`: exit 0, including unchanged PPID=1 orphan and whole-descendant-reaping checks. This resolves the prior environment precondition without weakening assertions.
- `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 5 60 W /usr/bin/bash tests/round7-external-floor-driver.sh`: exit 0. Public real external registration/start paused at floor entry; identical registration persisted under a new inode. Runner exited without polling/adopting, leaving replacement present. This is adversarial persisted-state mutation, NOT the public active-poll replacement test.
- `timeout -k 5 60 W /usr/bin/bash tests/round7-terminal-driver.sh`: exit 0. Claim terminal state at the superseded-floor boundary prevents launch, removes stale runner marker and preserves terminal claim.
- `timeout -k 5 120 W /usr/bin/bash tests/remote-delta-read.test.sh`: exit 0, exercising byte/digest/cursor protocol behavior.
- `LABEL=target FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 5 45 W /usr/bin/bash -x tests/round7-active-trace-driver.sh`: exit 124. Entered real external poll, then public register-extension blocked on lifecycle lock before expected ownership refusal. Instrumentation records real readiness/registration/claim/process tree and traces the replacing public command.
- `LABEL=baseline FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 5 45 W /usr/bin/bash -x .validation-tmp/baseline/tests/round7-active-trace-driver.sh`: exit 124 at the identical lock wait. Baseline exported from e1846c7 and locally Git-initialized for tracked-command validation; materialized index tree equals original baseline tree `cfcc2da62f9f451fe740330a349c965cc9888c2c` before evidence drivers were added.
- `timeout -k 10 160 W /usr/bin/bash .validation-tmp/baseline/tests/round7-remote-evidence-driver.sh`: exit 1 at `the header-collision line was not captured`. Same deterministic barrier assertions fail unchanged production and pass target.

Additional commands: git status/rev-parse/diff/archive/write-tree; bounded evidence listings/reads and driver diffs; command availability and namespace capability checks; disposable fixture construction and cleanup. No complete repository suite, linter, formatter, static analysis, publication, pipeline control, PR, or CI phase executed.

## Disposition

No-go, not green: active-poll replacement remains a failing live scenario on both target and unchanged baseline. The superseded-floor external refusal proof does not cover it. No demonstrated regression in the changed retry; its external-owner refusal passes. Current instructions prohibit unrelated locking changes, timeout increases, new guarantees, or tracked edits. Separate explicit authorization to repair the existing lifecycle-lock behavior is necessary to resolve the failing command; outer executor owns that decision. Do not retry this unchanged phase as though an in-scope handoff edit could solve this existing blocker.

This is a CLI/process surface; product-state records and command traces are appropriate evidence, with no rendered UI to screenshot.
