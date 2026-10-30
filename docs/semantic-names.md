# Semantic implementation names

Canonical filenames and functions describe responsibility, not a role-playing theme or a product abbreviation.
The [script index](scripts.md) lists current commands; script headers remain the authority for usage.

## File and skill mapping

For owned scripts, tests and extension modules, remove the old `fm-` prefix and apply the responsibility substitutions below, preserving descriptive suffixes such as `-lib`, `-check`, and `.test.sh`.
Other previously descriptive suffixes stay unchanged: for example, `fm-session-start.sh` is now `session-start.sh` and `fm-pr-merge.sh` is now `pr-merge.sh`.

| Old component | Canonical component |
| --- | --- |
| `spawn` / `teardown` / `brief` | `task-launch` / `task-cleanup` / `task-instructions` |
| `promote` / `crew-state` | `investigation-implement` / `task-state` |
| `send` / `peek` / `on` | `task-steer` / `task-inspect` / `remote-command` |
| `captain-hold` / `decision-hold` | `user-decision` / `legacy-decision-migration` |
| `secondmate` / `home-seed` | `project-coordinator` / `project-coordinator-provision` |
| `remote-home-seed` | `remote-project-coordinator-provision` |
| `fleet-sync` / `fleet-snapshot` / `fleet-view` | `project-sync` / `active-work-snapshot` / `active-work-view` |
| `fleet-ledger` / `bearings` | `activity-ledger` / `work-summary` |
| `dod` / `nm-run` / `ff` | `task-completion` / `validation-run` / `home-fast-forward` |
| `watch` / `wake` / `classify` / `check` | `supervision-watch` / `supervision-events` / `task-events` / `supervision-check` |
| `control` / `lease` / `guard` | `agent-control` / `supervision-lease` / `supervision-health` |
| `harness` / `backend` / `primary` | `agent-runtime` / `runtime-backend` / `coordinator` |
| `busy` / `composer` | `agent-activity` / `agent-input` |
| `branch` / `extension` | `supervision-branch` / `extension-host` |
| `afk` / `supervise-daemon` | `away-mode` / `away-supervision-daemon` |
| `sessionstart` / `turnend` | `session-open` / `turn-end` |
| `arm-pretool-check` / `arm-command-policy` | `supervision-pretool-check` / `supervision-command-policy` |
| `cd-pretool-check` / `cd-command-policy` | `working-directory-pretool-check` / `working-directory-command-policy` |
| `lock` / `lock-lib` / `tangle` | `session-lock` / `git-lock-lib` / `worktree-isolation` |
| `env` / `exclude-tools` / `role` | `environment-file` / `worker-tool-exclusions` / `publication-authority` |
| `line-cap` / `jev-mem-guard` | `digest-line-limit` / `memory-pressure-guard` |
| `procevent` / `x` | `process-events` / `relay` |
| `update` / `stow-cascade` | `self-update` / `memory-curation-cascade` |
| `calm-working-ship` / `calm-ship-raster` | `calm-progress` / `calm-progress-raster` |
| `fm_voice_frame.py` / `fm_voice_records.py` | `voice_frames.py` / `voice_records.py` |

Skill directories and their declared names use these mappings:

| Old skill | Canonical skill |
| --- | --- |
| `ahoy` / `bearings` / `stow` | `session-summary` / `work-summary` / `memory-curation` |
| `firstmate-coding-guidelines` / `firstmate-self-repo` | `coding-guidelines` / `self-repository-authority` |
| `firstmate-codexapp` / `firstmate-orca` | `codex-app-integration` / `orca-integration` |
| `firstmate-calm` | `calm-interface` (Claude plugin, not a skill) |
| `secondmate-provisioning` | `project-coordinator-provisioning` |
| `captain-hold-lifecycle` | `user-decision-lifecycle` |
| `scout-completion` / `ship-landing` | `investigation-completion` / `task-landing` |
| `stuck-crewmate-recovery` | `worker-recovery` |
| `updatefirstmate` / `updatespudrunner` | `self-update` / `update-spudrunner` |
| `fmx-respond` | `relay-responses` |

## Function mapping

Shell functions drop `fm_`, expand opaque responsibility prefixes, and use `project_coordinator`, `coordinator`, `worker`, `user`, `investigation`, and `implementation` instead of the old role terms.
A leading private-function underscore remains private.
For example, `fm_backend_detect` becomes `runtime_backend_detect`, `fm_dod_block` becomes `task_completion_block`, and `secondmate_registry_parse_line` becomes `project_coordinator_registry_parse_line`.

| Old prefix | Canonical prefix |
| --- | --- |
| `fm_backend_` / `fm_meta_` | `runtime_backend_` / `task_metadata_` |
| `fm_afk_` / `fm_super_` | `away_mode_` / `away_supervisor_` |
| `fm_procevent_` / `fm_pf_` | `process_events_` / `public_followup_` |
| `fm_nm_` / `fm_dod_` / `fm_ff_` | `validation_` / `task_completion_` / `home_fast_forward_` |
| `fm_sm_` / `fm_credsrc_` | `project_coordinator_liveness_` / `credential_source_` |
| `fm_busy_` / `fm_composer_` / `fm_control_` | `agent_activity_` / `agent_input_` / `agent_control_` |
| `fm_lease_` / `fm_wake_` / `fm_watcher_` | `supervision_lease_` / `supervision_events_` / `supervision_watcher_` |
| `fm_ps_` / `fm_win_` / `fm_sup_` | `process_table_` / `windows_process_` / `supervision_` |
| `fm_ship_` / `fm_mode_` / `fm_ask_` | `implementation_` / `delivery_mode_` / `validation_ask_` |

Extension exports likewise use responsibility names: `registerFirstmateTool` becomes `registerCoordinatorTool`, and `encodeFirstmateOperationalInput` becomes `encodeCoordinatorOperationalInput`.

## Compatibility and migration

Old `bin/fm-*` paths are thin compatibility entrypoints, not second implementations.
Shell entrypoints execute the canonical command when invoked and source it when imported, retaining legacy function aliases for sourced callers.
Old Python voice modules re-export the canonical modules, including the former `fleet_status` function as an alias of `active_work_status`.
Other old `bin/` module paths are symlinks to the canonical file.
Existing explicitly invoked skill commands have small redirect instructions; new discovery and generated instructions use canonical names.

Auto-discovered extension directories contain only canonical entrypoints, because keeping executable aliases there would register hooks twice.
Restart running coordinators and workers through the normal guarded update/relaunch paths after updating the code.
If a user-maintained configuration explicitly names an old `.pi`, `.omp`, `.opencode`, or Claude plugin path, update that reference to its canonical path before restarting; this change does not edit private settings automatically.
Internal functions imported directly from an auto-discovered extension must use the renamed exports.

Persisted and published identifiers deliberately retain their existing bytes: `FM_*` environment/configuration variables, `FM_TASK_ID`, `FIRSTMATE_OP`, `from-firstmate`, Pi `fm_*` tools and event names, `fm-*` endpoint labels, branch prefixes, lock/receipt markers, schema versions, launchd labels, existing task kinds and flags, and private filenames such as `data/captain.md`, `data/secondmates.md`, and `config/crew-dispatch.json`.
The external extension protocol still requires `firstmate-extension.json` and its existing schema identifiers.
The installed SSH entrypoint remains `fm-remote-entrypoint.sh`, pointing to the canonical `remote-entrypoint.sh`; both existing and new owned symlink targets are recognized without overwriting operator files.
External tool/project names, original-upstream URLs, licenses, vendor provenance, and historical attribution are unchanged.
These compatibility identifiers are not permission to create new opaque implementation names, nor do the new names change authorization or operational safety.
