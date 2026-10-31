# Focused Test fix result: blocked, not green

Final source SHA: `6c05bca9362dc80e1ead7461d4eb348935e95c80`.
No tracked files changed.

Reproduced the exact failing segment with `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner /usr/bin/bash -x tests/extension-host-binding.test.sh`, on both the target and an unchanged archive of baseline `e1846c7ba5c06a894673f7c7f85f9cc925b7f86b` inside this worktree. Each exited 124 at the 35-second bound after entering the active poll and invoking replacement `register-extension`, before the ownership-refusal assertion returned. Runs were sequential under exclusive flock on the existing `/home/andrew/spudrunner-green/serial-tests.lock` opened read-only, with a 45-second outer bound, 5-second lock acquisition bound, pinned tools and Node 22 paths. Fixtures used `/tmp` as incidental test-toolchain output and the script's normal cleanup. Global orphan reaping was disabled to avoid touching unrelated fixtures.

Root-cause boundary: `cmd_register_extension` acquires the extension lifecycle lock before reaching `extension_registration_replacement_safe_locked`; `cmd_extension_process_event` holds that lifecycle lock across the extension invocation. The active-block fixture cannot finish until its release file is touched, but the test only releases it after replacement returns. This is an existing active-poll lifecycle-lock wait, reproduced unchanged on baseline, not a new handoff regression. The target trace reaches the identical replacement call as baseline.

An initial attempt with TMPDIR inside the worktree failed package binding because trusted package sources cannot be inside a Git project; that setup error was corrected with TMPDIR=/tmp, not by modifying assertions. Its log is retained separately and is not presented as the active-poll reproduction.

The recorded human decision explicitly prohibits tracked edits, unrelated locking fixes, scope expansion and disguised approval of a failing command. Therefore no locking change, test skip, assertion weakening or timeout increase was applied. Resolving this pre-existing lock behavior needs separate authorization; the outer executor must keep this phase blocked rather than approve green. Prior round2 evidence is unchanged. No broad suite, linter, formatter, static analysis, publication or pipeline-control commands were run.

Evidence: `round3-target.log`, `round3-baseline.log`, `round3-invalid-fixture-location.log`. Temporary baseline archive and workspace test artifacts were removed after preserving logs.
