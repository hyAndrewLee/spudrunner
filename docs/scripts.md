# The bin/ toolbelt

See [semantic names and compatibility](semantic-names.md) for the old-to-new mapping and installed-home migration.
The main coordinator drives these; interactive entrypoints work by hand too, while `*-lib.sh` files are sourced helpers.
Each row is one purpose clause only: the script's own header comment is the authoritative description of its behavior, flags, and contracts, so read the header before first use.
If you have changed away from the Spudrunner home in an interactive shell, invoke these scripts by absolute path through the repo's `bin/` directory; the scripts self-locate internally after they start.
The shared no-mistakes gate lifecycle boundary is summarized in [architecture.md](architecture.md#no-mistakes-gate-authority-boundary), while `docs/session-open-nudge.md` covers the silent session-open hook use; `gate-refuse-lib.sh`'s header owns its exact contract.

| Script                   | Purpose                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------ |
| `session-start.sh`    | Compose lock, bootstrap, and wake drain into the single ordered session-start digest |
| `session-open-nudge.sh` | Print the native session-start hook nudge when the primary has not already run the digest |
| `session-open-run.sh` | Route a native session-open hook to the full digest, a context re-emit, or the nudge |
| `operational-input.sh` | Construct and parse the canonical cross-language operational-input protocol |
| `installation-check.sh`        | Detect toolchain and active work problems, run the locked session-start sweeps, and install approved tools |
| `startup-network.sh`  | Run session start's network checks and inactive-outcome scan off its blocking path, retaining reports and durable findings |
| `project-sync.sh`       | Refresh project clones with safe fast-forwards, self-heals, `STUCK:` reports, branch pruning, and bounded recovery from an orphaned `.git/packed-refs.lock` |
| `active-work-snapshot.sh`   | Print structured active work snapshot JSON and refresh only its parent-side remote-ledger cache (schema `fm-fleet-snapshot.v1`) |
| `home-summary-refresh.sh` | Atomically publish this home's structured summary ledger                         |
| `activity-ledger.sh`     | Append the opt-in active work activity ledger's records ([contract](fleet-ledger.md))      |
| `active-work-view.sh`       | Render the active work snapshot as a human Markdown view                                   |
| `work-summary-snapshot.sh` | Project the bounded remote-ledger active work snapshot to compact TOON; `--include-prs` adds live GitHub enrichment |
| `work-summary-board.sh`   | Build and arm the stable interactive `/work-summary lavish` active work board                  |
| `project-coordinator-reconcile.sh` | Queue Status summary reconcile requests for later supervision delivery and ask each mismatched home through its durable inbox with a per-home cooldown |
| `self-update.sh`           | Guarded self-update of Spudrunner and local or remote project coordinator homes, reconciling redundant divergence and classifying every live mate left on the target commit for restart or fallback nudge |
| `project-coordinator-restart.sh` | Persist open conversational work, then restart eligible project coordinators or report the fallback outcome |
| `project-coordinator-restart-lib.sh` | Shared second-mate restart capability and persistence-request contract |
| `remote-command.sh`               | Execute one tracked Spudrunner command in a configured remote project coordinator home, using its job worker except for the doctor bootstrap |
| `remote-job-lib.sh`   | Shared bounded remote job queue, worker readiness, LaunchAgent contract, and filesystem-composed PATH |
| `remote-job-worker.sh` | Long-lived remote queue worker for tracked `[a-z]*.sh` commands in the account runtime |
| `remote-job-reap-orphans.sh` | Stop remote job workers left running by a pruned code root, never one whose checkout still exists |
| `remote-doctor.sh`    | Check, and with `--fix` repair, one remote account's second-mate readiness (remote job worker, Herdr, Aqua launch agents, PATH, and required tools) |
| [`backlog-handoff.sh`](../bin/backlog-handoff.sh) | Move queued backlog items into a project coordinator home; its header owns route-specific wake outcomes and retries |
| `backlog-receive.sh`  | Idempotently ingest one confined remote handoff outbox through tasks-axi             |
| `user-decision.sh`     | Hold tasks for the user, record the user's answers, gate investigation completion, and report record divergence between the status log and the backlog |
| `legacy-decision-migration.sh`    | One-release compatibility shim mapping the retired decision commands onto user-decision.sh |
| `task-instructions.sh`            | Scaffold ship (explicit `--mode`, plus the project's registered `--forge` and `--pr`), investigation worker, secondmate-charter, and Herdr-lab briefs, with User intent and Implementation requirements subsections on ship/scout |
| [`task-completion-lib.sh`](../bin/task-completion-lib.sh) | Own ship/scout worker role scope, ship definitions of done, the named-head reachability gate on ship `done:` acceptance, and the no-mistakes `--intent` contract |
| `task-instructions-heading-lib.sh` | Single owner of reading a brief's sections, shared by the `--intent` contract, spawn and promotion validation, and `dispatch-resolve.sh` |
| `herdr-lab.sh`        | Provision and guardedly operate an isolated, never-default Herdr lab session         |
| `herdr-lab-viewer.py` | The pty engine behind `herdr-lab.sh viewer`: one real foreground Herdr client on a non-zero window grid |
| `lab-home.sh`         | Mint disposable lab homes and manage their isolated tmux socket directories       |
| `live-lab.sh`         | Build and operate a disposable live supervision lab; see its header for usage and readiness contract |
| `install-herdr.sh`    | Install CI's exact-version Herdr pin with official asset URL, SHA-256, and protocol checks |
| `install-treehouse.sh`| Install CI's exact-version Treehouse pin for real-Herdr E2E that needs spawn worktrees |
| `herdr-ci-cleanup.sh` | Snapshot and tear down only job-owned `fm-lab-*` sessions in the Herdr CI lane       |
| `rex-marks.sh`        | Opt-in: turn each Rex task's latest status into one badge and notification on its pane, plus validation progress and an optional tint (`plan`, `sync`, `clear`); the watcher runs `sync` each poll while the option or a cached record exists, and cleanup runs `clear` |
| `test-run.sh`         | Behavior-test runner: selection, portable lanes, bounded concurrency, budgets, coverage guard, timing/JSON; refuses to execute in the repository primary checkout when `FM_TASK_ID` marks a task worker |
| `test-isolation-proof.sh` | Concurrent isolation harness and portable candidate set owner |
| `ensure-agents-md.sh` | Manually initialize project agent-memory files (see the helper's header and help) |
| `capacity.sh`         | Report of open lanes against the optional `config/lane-capacity` target and host headroom for queued-work dispatch; `--publish` writes this home's `state/lane-capacity.json` |
| `supervision-health.sh`            | Warn on primary-checkout tangles, main-session pending wakes, and unhealthy supervision |
| `coordinator-scope-lib.sh` | Shared marker-or-plain-checkout primary-home predicate for tracked hooks             |
| `session-lock-lib.sh` | Shared session-lock ownership from harness ancestry, a trusted Claude session id, or on Windows/Git Bash a published harness pid, for session-lock.sh and the Claude Stop auto-arm, plus the read-only lock inspection behind `session-lock.sh status` and `inbox.sh ready` |
| `claude-stop-autoarm.sh` | Claude Stop `asyncRewake` hook owning tokenless watcher continuity with single-flight exit-2 rewake (docs/watcher-continuity.md) |
| `turn-end-guard.sh`    | Shared primary turn-end guard predicate so no turn ends blind (docs/turn-end-guard.md) |
| `turn-end-guard-grok.sh` | Grok Stop-hook adapter for the primary turn-end guard                              |
| `kimi-turn-end-hook.sh` | Surgically install or remove Kimi's guarded global crew turn-end hook                |
| `supervision-pretool-check.sh` | Stable PreToolUse transport for the watcher-arm command policy (docs/arm-pretool-check.md) |
| `supervision-command-policy.mjs` | Semantic owner of the watcher-arm PreToolUse policy (docs/arm-pretool-check.md)   |
| `subagent-pretool-check.sh` | Primary-home delegation-shape PreToolUse guard (docs/subagent-guard.md) |
| `supervision-instructions.sh` | Render the session-start primary-harness supervision block or the one-line repair instruction |
| `project-coordinator-provision.sh`        | Transactionally provision a local project coordinator home and maintain `data/secondmates.md` |
| `remote-project-coordinator-provision.sh` | Register and provision a whole project coordinator home on an SSH-reachable host              |
| `remote-readiness-lib.sh` | Shared remote second-mate readiness gate: check and, when needed, repair then re-check through `remote-doctor.sh` |
| [`project-origin-lib.sh`](../bin/project-origin-lib.sh) | Accepted origin-form owner shared by both remote provisioning boundaries |
| `task-launch.sh`            | Spawn implementation workers, investigation workers, `id=repo` batches, and project coordinators on the resolved harness and runtime backend |
| [`approval-failover.sh`](../bin/approval-failover.sh) | Save a user-approved managed-approval fallback and recover a worker after observed defeated bypass |
| `git-strip-ai-trailers.sh` | Strip known AI commit trailers at commit-msg time and install that hook, plus any forge=external push guard, for a active work launch |
| `git-push-guard.sh`  | Refuse a forge=external task's pushes to the shared origin and of task-prefixed branches, and write its per-task guard record ([design](external-review-forge.md)) |
| `runtime-backend.sh`          | Runtime-backend selection, meta helpers, selector resolution, and operation dispatch |
| `runtime-backend-hometag-lib.sh` | Shared per-installation home-tag derivation for zellij tab, cmux workspace, and tern session titles |
| `agent-input-lib.sh`     | Single fleet-wide owner of composer shapes, capability-aware screen classification, and verdicts |
| `agent-process-lib.sh` | Backend-neutral harness-process name classifier shared by recovery-grade adapters |
| `backends/tmux.sh`       | Verified tmux session-provider adapter                                               |
| `backends/herdr.sh`      | Herdr session-provider adapter with its own required CI lane                         |
| `backends/zellij.sh`     | Experimental zellij session-provider adapter                                         |
| `backends/orca.sh`       | Experimental Orca backend adapter owning both worktree and terminal                  |
| `backends/cmux.sh`       | Experimental cmux session-provider adapter                                           |
| `backends/paseo.sh`      | Experimental Paseo session-provider adapter                                          |
| `backends/rex.sh`        | Experimental Rex session-provider adapter                                            |
| `backends/t3code.sh`     | Experimental T3 Code adapter driving the agent session through `t3code-mcp.mjs`       |
| `backends/tern.sh`       | Experimental tern session-provider adapter                                           |
| `config-push.sh`      | Push declared inherited local material to live local or remote project coordinators and send the placement-specific config reread when changed |
| `project-mode.sh`     | Resolve a project's registered delivery posture, forge binding, PR-text binding, or ship-branch prefix from `data/projects.md` for active work sync, home seeding, and the forge and PR-text agreements a ship spawn or investigation worker promotion applies |
| `forge-detect.sh`     | Propose a clone's forge binding from its origin remote for project-add intake, never recording it |
| [`merge-local.sh`](../bin/merge-local.sh) | Fast-forward a `local-only` project's local default branch to the approved recorded commit |
| `review-diff.sh`      | Review an implementation worker branch or resolved PR head against the authoritative base          |
| `marker-lib.sh`       | Compatibility entry point for the from-firstmate carrier owned by `operational-input.sh` |
| `task-inbox-lib.sh`   | Single owner of durable steering-inbox records, acknowledgement, doorbells, and the delivery-attempt ladder |
| `pending-reply-lib.sh` | Parent-owned project coordinator pending-reply expectations, recovery, and keyed escalation lifecycle |
| `project-coordinator-report.sh` | Optional helper that resolves the parent channel itself and appends a correlated status or document-pointer report |
| `extension-host.mjs`       | Bind, inspect, verify, and strictly invoke trusted external process-event adapter packages |
| `extension-host-launch-barrier.mjs` | Publish one exact static core-owned invocation group before package code runs |
| `t3code-mcp.mjs`          | T3 Code `/mcp` client: captain-run sign-in, capability gate, and the thread verbs the t3code adapter calls (docs/t3code-backend.md) |
| `t3code-answer.sh`        | Read or answer a recorded T3 worker's pending questions                              |
| `t3code-codex-env.sh` | Manage the T3 environment overlay on tracked Codex project configuration              |
| `extension-host.sh`        | Expose extension binding commands through the tracked shell and remote-home command boundary |
| `process-events.sh`        | Register, supervise, capture, classify, acknowledge, and safely retire built-in or explicitly bound process-event sources |
| `process-events-remote-reply.sh` | Relay the remote-secondmate status stream through non-destructive process-event deltas |
| `process-events-quota.sh`  | Wake Spudrunner when tracked quota drops below a threshold, is exhausted, or cannot be polled |
| `process-events-when.sh`   | Fire a trust-bound deterministic action at most once when its registered condition holds, then wake with the outcome |
| `gate-refuse-lib.sh`  | Shared gate-context lifecycle boundary for real and lab homes                      |
| `supervision-watch-arm.sh`        | Verified home-scoped watcher arm wrapper with loud cycle endings and bounded lifecycle ledger |
| `supervision-watch-checkpoint.sh` | Run one bounded foreground watcher checkpoint for Codex-style supervision            |
| `supervision-watch.sh`            | Singleton-safe watcher: absorb benign wakes, detect stalled local-secondmate wake queues, and exit on actionable ones |
| `inactive-reconcile.sh` | Reconcile long-inactive direct implementation worker terminal outcomes without forge access |
| `away-mode-contract.sh`     | Own the away-or-quiet record's posture, schema, entry, read-back, archive, and cross-subsystem authority lock |
| `away-mode-start.sh`        | Run the common sourceable away-mode daemon entry in the foreground                      |
| `away-mode-launch.sh`       | Own away/quiet entry (same-turn record write, then read-back), exit, rollback, and any backend terminal lifecycle |
| `away-mode-return.sh`       | Own deterministic return shutdown, the return brief, catch-up evidence, and the firstmate-actionable blocker gate |
| `supervisor-target-lib.sh` | Resolve the shared supervisor target and backend for the daemon and launcher       |
| `away-supervision-daemon.sh` | Presence-gated away-mode sub-supervisor: self-handle routine wakes, guard injection by the detected primary harness, escalate batched digests, alert on failed delivery |
| `task-state.sh`       | Print one deterministic current-state line for a crew                                |
| `validation-run-lib.sh`       | Single owner of shared no-mistakes run-attribution primitives and rules             |
| `pipeline-spend.sh`   | Attribute a task's no-mistakes pipeline spend to the task and keep it in the private spend ledger |
| `worktree-isolation-lib.sh`       | Shared default-branch resolution and primary-checkout tangle classification          |
| `timeout-lib.sh`      | Single owner of hard-bounded command execution and its fallback watchdog |
| `timing-lib.sh`       | Single owner of the deferred network stage's per-step elapsed-time records, inert unless a run asks for them |
| `supervision-lib.sh`  | Shared in-flight-work-without-fresh-watcher-beacon predicate                         |
| `home-fast-forward-lib.sh`           | Shared guarded fast-forward/reconcile helper for origin pulls and project coordinator syncs, with durable divergence markers |
| `git-lock-lib.sh`         | Shared "is this git lock provably abandoned?" proof used by teardown and fleet-sync   |
| `config-inherit-lib.sh` | Shared primary-to-secondmate inherited local-material propagation and config-reread delivery |
| `tasks-axi.sh`        | Run `tasks-axi` against this home's backlog from any working directory               |
| `tasks-axi-lib.sh`    | Shared backlog-backend selector and `tasks-axi` compatibility probe                  |
| `backlog-transition-lib.sh` | Pair task-record changes with their backlog transitions and replay interrupted closes |
| `quota-axi-lib.sh`    | Shared `quota-axi` compatibility floor and quota snapshot schema validation           |
| `credential-source-lib.sh` | Single owner of the declared credential-source schema and its adapters, read by `dispatch-resolve.sh` and checked by `installation-check.sh` |
| `quota-choose.sh`     | Choose the first candidate with known positive quota from an ordered harness:model list |
| `vendor-auth-probe.sh`| Run one hard-bounded, non-destructive authentication probe of a named vendor CLI and report the fact |
| `supervision-events-drain.sh`       | Present and acknowledge the current actor's claimed wake rows alongside status, outcome-backstop, decision, divergence, supervision-host outcome, recovery, and supervision checks |
| `supervision-events-grant.sh`       | Serialize Pi supervision-branch wake-row claim activation, publication, release, and deactivation |
| `supervision-events-lib.sh`         | Shared durable wake queue, recovery generations, portable locks, and watcher identity/health helpers |
| `path-lib.sh`         | Fork-free `dirname`/`basename` equivalents with no source-time side effects             |
| `task-events-lib.sh`     | Shared wake classification, durable keyed-decision folds and scans, unread status selection, home-owned status-append ranges, and bounded latest-event snapshots |
| `task-steer.sh`             | Steer a task via a durable inbox record plus doorbell, or send a supported key or typed harness invocation through the recorded backend |
| `supervision-branch-prompt.sh`    | Emit the shared supervision branch's byte-stable system prompt ([pi-supervision-branch.md](pi-supervision-branch.md), [supervision-host.md](supervision-host.md)) |
| `supervision-branch-outcome.sh`   | Own the supervision branch's append-only outcome store, cursors, bounded status-coverage indexes, and session-start replay |
| `supervision-lease.sh`            | Claim, release, inspect, and sweep per-task supervision leases                       |
| `supervision-lease-lib.sh`        | One owner of the supervision lease contract and the main-only role-partition guards  |
| `agent-control.sh`          | Agent lifecycle control plane: allowlisted `interrupt`, `exit`, and transactional `relaunch` verbs for an exact task id ([agent-control.md](agent-control.md)) |
| `agent-control-lib.sh`      | One executable owner of the control-plane verb allowlist, per-harness interrupt/exit mechanics, per-backend capability, and the endpoint-absence proof both `exit` and `relaunch` read |
| `agent-activity-lib.sh`         | Single owner of the semantic busy-state contract: verdicts, source attribution, and per-harness sources |
| `agent-activity-event.sh`       | The only writer of a task's semantic busy-state record and native-harness progress marker; arms an incarnation and applies lifecycle events |
| `tmux-lib.sh`         | Shared tmux pane primitives for composer capture, verified submit, and the submit-time busy check |
| `task-inspect.sh`             | Print a bounded tail of an implementation worker endpoint                                          |
| `supervision-check-register.sh`   | Bind an intentional custom watcher check to its current bytes                       |
| `supervision-check-unregister.sh` | Retire a custom watcher check and its trust binding by validated task id            |
| `supervision-check-lib.sh`        | Validate custom-check registrations and prepare private execution snapshots          |
| `tool-update-check.sh` | Report watched tooling with an update available, and updates installed but left inert by PATH order |
| `startup-growth-check.sh` | Daily metadata-only growth check for startup memory and tracked startup/instruction surfaces |
| `usage-warner.sh`     | Opt-in macOS threshold warner that notifies once when a configured Claude usage window crosses its percentage |
| `pr-lib.sh`           | Own canonical task and PR validation, the branch-to-PR lookup shared by teardown and the PR health monitor, plus private atomic PR-poll publication, merge-notification identity, and retirement |
| `pr-poll.sh`          | Provide the byte-static watcher program for validated pull-request, merge-request, and Gerrit-change poll sidecars |
| `contributions.sh`    | Observe owned publications, retain exact-head judgments, measure required actors, and wake on maintainer or configured review-bot signals |
| `pr-health.sh`        | Opt-in: enroll the PRs this home owns from creation and notify once per condition per latest commit for a conflict or failing required check (see [configuration.md](configuration.md#pr-health-monitor-configpr-health-monitor)) |
| `pr-check.sh`         | Record validated task `pr=` and `pr_head=` values, then atomically arm a static merge poll; refuses GitHub drafts and persistent project coordinator records (see [architecture.md](architecture.md)) |
| `review-check.sh`    | Record a forge=external task's validated `review=` and `review_head=` without arming a merge watch ([design](external-review-forge.md)) |
| `external-review-lib.sh` | Shared readers for the forge=external review tool adapter, ready-URL pattern, backup remote, and remote URLs |
| `pr-merge.sh`         | Record PR metadata, merge a task's canonical full GitHub, GitLab, or Forgejo URL, refuse a Gerrit change because Spudrunner never submits one, then refuse an outcome it cannot prove landed or queued |
| `pr-state.sh`         | Read-only: print one line per GitHub pull-request blocker it can see, reporting on checks that have reported rather than verdicting merge-readiness |
| `pr-reviewers.sh`     | Read-only: suggest reviewers from GitHub's own author mapping of recent commits on a pull request's changed files, never requesting one |
| `merge-outcome-lib.sh` | Publish a confirmed merge's durable, role-routed supervision outcome                 |
| `merge-authority-lib.sh` | Resolve merge authority at the gate, persist it against the accepted canonical PR, and identity-check its later poll consumption |
| `parent-channel-lib.sh` | Resolve a project coordinator home's parent channel and append a user-facing outcome line to it at most once |
| `investigation-implement.sh`          | Promote an investigation worker task in place to a protected implementation task with an explicit delivery mode, write the ship instructions carrying that mode's definition of done, and supersede the task's brief so a later relaunch cannot revive stale investigation worker delivery text |
| `task-cleanup.sh`         | Fail-closed teardown: return landed ship worktrees, require completed investigation worker deliverables, retire project coordinator homes |
| `agent-runtime.sh`          | Detect the running harness, resolve crew or project coordinator harness, model, and effort, and validate the native-only `ultra` effort |
| `session-lock.sh`             | Per-home Spudrunner session lock                                                      |
| `relay-lib.sh`            | Shared Relay config, relay, and reply-threading helpers                              |
| `relay-poll.sh`           | One bounded Relay poll: stash newly offered mentions, emit their once-only wake, and raise queued public-followup rejection wakes at least once |
| `relay-reply.sh`          | Post or dry-run preview a composed Relay reply or follow-up                          |
| `relay-dismiss.sh`        | Dismiss a skipped Relay mention at the relay without replying                        |
| `relay-link.sh`           | Link a spawned task to its originating Relay mention in task meta                    |
| `relay-followup.sh`       | Detect, post, and cap completion follow-ups for a Relay-linked task                  |
| `public-followup-lib.sh` | Shared Relay gate, mirrored deliverable validation, open-loop state, locking, and private transport paths |
| `public-followup.sh`  | Brief, reconcile, and deliver typed public commitments, surface refusals, then rechain or retire retained loops |
| `public-followup-emit.sh` | Validate and report one typed terminal work result into its owning home, or stage it when that home is remote |
| `public-followup-collect.sh` | Read and retire the typed terminal results a remote work home staged for the home that owes the public reply |
| `inbox.sh`            | The user's out-of-band capture surface: queue a note (optionally idempotent by request id), announce or repair its wake, record a durable primary reply, and emit bounded receipts and primary-readiness JSON |
| `mail-client.sh`             | General-purpose mail plane: read unseen IMAP mail, send one SMTP message, or surface new mail as a `check` wake via `poll` (configuration in the home's gitignored `.env`) |
| `mail-client.py`             | The IMAP/SMTP engine behind `mail-client.sh` |
| `mail-monitor.sh`       | Standing received-mail poll: `arm` registers a watcher check that runs `mail-client.sh poll` on the watcher cadence (new mail still wakes via the poll; the check's own line also wakes unless the poll is a proven no-op), `disarm` removes it |
| `voice-relay.py`      | Hold the spoken conversation on this host, answer from the records, and hand real work to `inbox.sh` ([voice-relay.md](voice-relay.md)) |
| `voice-client.py`     | The laptop end of the spoken interface: capture, playback, and turn timing over SSH; audio devices unverified |
| `voice_frames.py`      | The wire format both machines share, copied to the laptop beside the client          |
| `voice_records.py`    | What a spoken answer may read, and the handover that queues real work                |
