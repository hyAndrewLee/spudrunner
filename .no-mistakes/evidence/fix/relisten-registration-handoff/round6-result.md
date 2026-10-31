# Targeted Test phase blocked

HEAD: 6c05bca9362dc80e1ead7461d4eb348935e95c80. No tracked changes.

Reproduced the exact failing lifecycle-runner segment using the preserved round5 namespace wrapper and PID-1 reaper, disposable worktree-backed HOME/passwd/tmp, pinned Node/tool prefixes, CPU limit 600 seconds, descriptor limit 1024, exclusive read-open /home/andrew/spudrunner-green/serial-tests.lock (10-second acquisition bound), and outer timeout -k 5 45. Command: FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 5 45 bash .validation-tmp/run-isolated.sh /usr/bin/bash -x tests/extension-host-binding.test.sh. Exit 124. Trace retained in round6-active-reproduction.log: the poll readiness barrier completed, then execution stopped inside replacement register-extension at the expected prior-runner-refusal assertion.

Prior preserved round5 target/baseline lock traces establish the same lifecycle-lock wait on unchanged baseline; this new reproduction agrees with that evidence. The triggering operation is registration replacement during an active external poll; the active poll retaining the lifecycle lock prevents reaching the ownership refusal. The symptom is a timed-out public command, not a demonstrated handoff-retry regression. The pre-poll superseded-floor refusal is not equivalent to this scenario.

Recorded human scope prohibits unrelated locking repairs, new guarantees, tracked edits and timeout increases. No fix is authorized for this baseline defect in this phase. Separate explicit authorization to repair the existing active-poll lifecycle locking is required. Result remains blocked, not green. No broad suite, lint, formatter, static analysis, publication or pipeline-control commands ran. Transient fixtures removed; earlier evidence preserved.
