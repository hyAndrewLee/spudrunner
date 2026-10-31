# Test phase: repair verified, existing active-extension blocker remains

Final HEAD: `6c05bca9362dc80e1ead7461d4eb348935e95c80`. No tracked files changed. Transient drivers, archived baseline and generated fixtures removed. All earlier evidence preserved.

## Execution environment

Used supported unshare user/PID/mount namespaces with a private PID-1 Python reaper, namespace-local /tmp and account mapping backed entirely by this worktree, dropped capabilities, and disposable HOME. This solves the WSL orphan-precondition failure without weakening or skipping assertions. Docker's PATH command reports WSL integration unavailable; no host search or installation was needed. Each run held exclusive flock on the existing `/home/andrew/spudrunner-green/serial-tests.lock`, opened read-only, acquisition bound 10s. Pinned PATH prefixes were `/home/andrew/.nvm/versions/node/v22.23.3/bin:/home/andrew/spudrunner-green/tools`; entry shell `/usr/bin/bash`, CPU bound 600s, descriptors 1024. Wrapper and PID-1 script are retained as round5-run-isolated.sh and round5-pid1.py. Mounts existed only in the disposable namespace; no host /etc or /tmp files were changed by them.

## Exact executions and results

All commands below were prefixed with `/usr/bin/timeout -k <kill-grace> <wall-seconds> /usr/bin/bash .validation-tmp/run-isolated.sh`:

- `-k 10 650 /usr/bin/bash tests/process-events.test.sh`: exit 0, including unchanged orphan PPID=1 and descendant-reaping assertions.
- `-k 10 360 /usr/bin/bash tests/remote-reply.test.sh`: exit 0, including deterministic plain/NUL handoff and command/adapter/missing/home/PID/token/one-shot refusals.
- `-k 10 360 /usr/bin/bash tests/round5-remote-evidence-driver.sh`: exit 0; identical assertions plus persisted claim, capture, normalized stream and cursor evidence.
- `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner ... -k 5 60 /usr/bin/bash tests/round5-external-floor-driver.sh`: exit 0. Real bound extension runner paused at launch-floor entry; identical-content registration inode replaced; runner exited without polling/adopting and replacement remained. This adversarial persisted-registration mutation is not a public active-poll replacement proof.
- `LABEL=target FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner ... -k 5 45 /usr/bin/bash -x tests/round5-active-trace-driver.sh`: exit 124.
- `LABEL=baseline FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner ... -k 5 45 /usr/bin/bash -x .validation-tmp/baseline/tests/round5-active-trace-driver.sh`: exit 124. Driver preserves the existing lifecycle-runner assertions, adding trace output and product-state capture only. Both runs entered the real active-block poll and blocked replacement register-extension on the extension lifecycle lock before the ownership-refusal assertion returned. This reproduces the previous limitation on unchanged baseline, not a handoff regression. Target and baseline diagnostic logs record actual poll readiness, registration, claim, and private process tree; lock traces show the waiting call.
- `-k 10 160 /usr/bin/bash .validation-tmp/baseline/tests/round5-remote-evidence-driver.sh`: initial archive-only setup failed tracked-remote-command validation. Corrected locally by initializing a disposable Git repository with exactly the baseline tree (`cfcc2da62f9f451fe740330a349c965cc9888c2c`) before copying in the evidence driver. Same command then exited 1 at `the header-collision line was not captured`, reproducing the handoff defect at the barrier. Target passes that same assertion without fallback start/reconcile.
- `-k 5 120 /usr/bin/bash tests/remote-delta-read.test.sh`: exit 0, including byte/digest/cursor protocol checks.
- `-k 5 60 /usr/bin/bash tests/round5-terminal-driver.sh`: exit 0. Reused exact launch-floor refusal fixture with claim terminal state; neither command launched and terminal claim was preserved. This tests retired ownership at the changed retry boundary, separately from missing registration.

## Disposition

No-go: the active-extension replacement check remains failing on target and baseline. The pre-poll external superseded-floor proof is useful but is not the active-poll test. No green approval, locking repair, timeout/configuration change, weakened assertion, fallback restart, or source fix was applied. Current authority explicitly forbids unrelated locking changes; separate explicit authorization for that existing lifecycle-lock failure is required before this failing Test command can be resolved. The outer executor owns the decision and all other phases.

The repair's live CLI surface is demonstrated by real local process-event and remote-reply runners. SSH transport is an isolated local shim executing the real remote entrypoint and delta reader, not a real network connection; no hosted failure attribution is claimed. This is a CLI/process change with no rendered UI, so screenshots are not applicable. No full repository suite, linter, formatter, push, PR, CI, or pipeline-control commands were run. Git inspection, baseline archive/tree identity comparison, environment capability checks, temporary evidence instrumentation and cleanup are included in the phase work.
