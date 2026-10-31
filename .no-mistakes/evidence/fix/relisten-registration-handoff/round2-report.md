# Test-phase result

Final source SHA: `6c05bca9362dc80e1ead7461d4eb348935e95c80`.
Baseline: `e1846c7ba5c06a894673f7c7f85f9cc925b7f86b`.
No tracked files changed. No lint, broad repository suite, pipeline control, publication, or CI actions ran.

## Demonstrated behavior

- The complete targeted `tests/process-events.test.sh` passed in a private user/PID/mount namespace with a PID-1 Python reaper. In particular its unchanged PPID-1 reproduction assertion and orphan/descendant cleanup proofs passed. This resolves the previous round's environment blocker without changing or skipping assertions.
- The complete `tests/remote-reply.test.sh` passed. Public handler re-registration at FIFO launch-entry barriers retained the same PID/token for subsequent plain text and NUL-bearing payloads, without fallback start or reconciliation. Changed command, changed adapter, absent registration, wrong home/PID/token, and one-shot refusals passed. Existing normalization, digest, cursor and control assertions remained in place.
- The same current regression test against archived baseline production failed at the expected next plain-text capture after the handoff replacement. This baseline archive was given a disposable Git index because remote-command validates tracked executables; the earlier index-less attempt was invalid setup, not regression evidence. Baseline production file hash matches `git show` (see provenance).
- An evidence-only copy of the remote test also passed in full, copying actual `.result`, cursor, mirrored status and barrier/claim records immediately after the NUL capture. `round2-handoff-state/5.ready` and `6.ready` contain the same PID/token but different adopted identities; the final claim retains that PID/token. Result payloads and mirrored status show `status=delta` and `before?after`.
- A disposable external-extension fixture used real binding/registration/start interfaces and a launch-entry FIFO barrier. Atomic inode replacement of its persisted registration caused the extension-owned runner to exit 0 without invoking source.poll, adopting a claim, or modifying the registered owner token. This is adversarial pre-poll evidence, not a substitute for the active-poll case below.
- `tests/remote-delta-read.test.sh` passed.

## Remaining active-poll limitation (not green)

`FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner /usr/bin/bash tests/extension-host-binding.test.sh` timed out at 100 seconds. Additional traced runs on both target and unchanged baseline production each timed out at 35 seconds. Both really entered the external poll, then stopped inside the attempted public `register-extension ... --config-ref replacement` operation. Runtime traces show that operation waiting for `.extension-binding-lifecycle.lock`, whose live holder differs from the registration caller. It has not reached the replacement-safety refusal. Thus the timeout is reproduced on baseline and localized before any superseded-floor retry; it is not evidence of a new handoff regression, and it is not a passing external-owner active-poll test. No timeout was increased and no locking change or extra guarantee was introduced. The existing refusal assertion could not finish; this failing command remains an approval blocker for the outer executor to resolve under separate authority.

See `round2-external-timeout-excerpt.log` and the full target/baseline traces. The pre-poll proof above demonstrates that the changed retry does not adopt an extension owner, but does not claim the active-poll test passed.

## Execution / isolation

Heavy commands ran sequentially while holding the existing lock via read-only FD 9:

`( /home/linuxbrew/.linuxbrew/bin/flock -x -w 20 9; <bounded commands> ) 9< /home/andrew/spudrunner-green/serial-tests.lock`

Successful isolation wrapper:

`timeout -k 10 <seconds> /home/linuxbrew/.linuxbrew/bin/unshare --user --map-current-user --pid --fork --kill-child --mount-proc /usr/bin/python3 .validation/pid1.py /usr/bin/bash <test>`

`round2-pid1.py` preserves the test exit status and reaps orphaned children; namespace termination bounds surviving processes. Process-event timeout: 720 seconds; remote tests: 180–240 seconds; external probe: 20-second FIFO wait and 180-second outer ceiling; active-poll runs: 100 seconds, then 35 seconds per traced comparison. Later comparison/evidence runs additionally used `ulimit -t 180` and `NODE_OPTIONS=--max-old-space-size=256`.

Pinned PATH: `/home/andrew/.nvm/versions/node/v22.23.3/bin:/home/andrew/spudrunner-green/tools:/usr/bin:/bin:/home/linuxbrew/.linuxbrew/bin`. Namespace, lock, Python and Bash executables were explicitly addressed. Tool versions are in `round2-provenance.log`.

Final remote/external fixtures used `TMPDIR=/tmp`, the explicitly permitted incidental test-toolchain temporary-data exception. An initial workspace-nested TMPDIR caused an early remote exit 64 and extension package rejection as being inside a Git project; those were setup failures, not handoff findings. An initial root-mapped namespace invalidated permission assertions, and a subsequent unqualified system unshare lacked `--map-current-user`; both were corrected by using the explicitly pinned Homebrew unshare and current-user mapping. Their logs are retained rather than represented as passes. No host tool search or installation was needed.

The first successful process-event run used workspace-local TMPDIR and the corrected namespace; its entire log ends `all procevent tests passed`. Evidence-only scripts and archived baseline were confined to `.validation/`, then removed. Existing earlier evidence was not removed. This is a CLI/process surface, so persisted byte contracts and runtime transcripts, not screenshots, are the appropriate artifacts.
