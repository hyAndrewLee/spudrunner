# Workflow integration

The [worker-engineering skill](../.agents/skills/worker-engineering/SKILL.md) owns the effective engineering defaults.
The [concise-chat skill](../.agents/skills/concise-chat/SKILL.md) owns main-chat style.
[Source provenance](workflow-sources.md) owns pins, licenses, and deliberate deviations.
These are defaults inside the existing lifecycle, not a new agent product or a replacement supervisor.

## Effective instructions

`bin/task-completion-lib.sh` renders an absolute code-root skill path into ordinary task instructions.
`bin/task-instructions.sh` includes it in new instructions; the common `bin/task-launch.sh` launch overlay reapplies it for fresh workers, older saved instructions, and relaunches.
`bin/investigation-implement.sh` includes the same policy in both live conversion instructions and the durable replacement used by future relaunches.
Project coordinators retain their existing charter contract.
Workers in unrelated project repositories read the absolute path instead of relying on discovery of this repository's skills.
Engineering defaults stay outside user intent and the final authorized `--intent` section.
The skill's authority and precedence section is the single owner of its scope limits.

The shared launch path is independent of the selected supported worker harness and runtime backend.
It covers terminal and non-terminal launches because the adapters consume the same prepared instructions.
No vendor-emitted signals, trust classification, runtime lifecycle actions, or backend selection mechanics change.

## Pi capability mapping

| Need in upstream workflow | Spudrunner behavior |
| --- | --- |
| Read, edit, write, shell, tests | Use available native worker tools; report an unavailable prerequisite. |
| Cursor Task/background, poteto-agent | No equivalent API assumed; workers do the assigned work directly. |
| arena, architect, interrogate | Not part of this adaptation; existing selected delivery owns review. |
| create-skill | Author ordinary skill files only when explicitly scoped; no Cursor built-in dependency. |
| babysit and loop | Existing coordinator supervision and delivery, no second monitor or autonomous loop. |
| Git branches and isolated copies | Existing launch isolation and unlanded-work protection, never copied reset/recovery rules. |
| Model catalogs and defaults | Existing harness-authoritative dispatch catalog and configured profiles, no hardcoded model. |
| Main conversation compression | Instruction-only concise prose, no extension or runtime compressor. |

The same capability boundary applies to every other supported harness; available tools are established at dispatch rather than inferred from a name.
No adapter gains authority to delegate, publish, merge, discard, or contact third parties from these defaults.

## Verification

Extend the existing brief, intent, promotion, launch, role-target, and dispatch behavioral fixtures.
Check source hashes against the manifest, absolute policy paths, separation of original intent, and old/new heading compatibility.
Run `bin/doc-audience-check.sh` and `bin/lint.sh`; CI remains the owner of broad regression coverage.
Missing local tools are limitations, not passing checks.
A future vendor-dependent change still requires the live proof described by [coding guidelines](../.agents/skills/coding-guidelines/SKILL.md).
