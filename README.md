# Spudrunner

One main coordinator, isolated implementation and investigation workers, explicit approvals.
Spudrunner is a public [Firstmate](https://github.com/kunchenguid/firstmate) fork with neutral naming, selected Poteto engineering defaults, and concise Caveman-inspired main chat.
It is an instruction-and-tooling distribution, not a new model, coding harness, MCP server, or standalone CLI.

## How it works

You give the main coordinator a request.
It routes the request to an implementation worker for changes or an investigation worker for a standalone answer.
Each worker receives an isolated copy, original user intent, separate implementation requirements, and the bounded engineering policy.
The existing selected delivery path owns review, tests, and publication; this fork adds no parallel reviewer or supervisor.
The coordinator reports results and full PR URLs, and asks for decisions or merge approval when required.
Optional project coordinators provide persistent local or SSH-reachable domains.

- **Small, evidence-based changes:** selected Poteto principles and playbooks, explicitly adapted rather than claimed as a drop-in install.
- **Concise conversation:** answer first, no mandatory address or nautical phrases, full evidence and warnings preserved.
- **Normal artifacts:** documents, reports, code, comments, commits, and PRs retain normal prose.
- **Preserved safety:** scoped authority, isolated work, unlanded-work protection, explicit publication consent, and configured merge approval remain authoritative.
- **Compatible internals:** existing `fm-`, `fm_`, `FM_`, tools, command names, protocol tokens, and saved records remain supported.

See [workflow sources and licenses](docs/workflow-sources.md), [integration ownership](docs/workflow-integration.md), and [naming conventions](docs/naming-conventions.md).
This is a Firstmate-compatible Poteto adaptation, not an installation of Cursor Task, arena, architect, interrogate, babysit, or a Caveman runtime product.

<a id="requirements"></a>
## Setup

Requirements: Git, authenticated GitHub tooling, a supported coding harness, and the dependencies of your selected session backend.
The coordinator asks before installing or upgrading missing tools; it does not treat defaults as installation permission.

```sh
gh auth login
git clone https://github.com/hyAndrewLee/spudrunner.git
cd spudrunner
```

Launch a supported primary harness in that directory:

```sh
claude
# or
grok --trust
# or
pi
# or, if the signed wrapper is installed
FM_PI_HARNESS=pi-signed pi-signed
# or
omp
```

Claude Code, Grok, and Pi are equal co-primary recommendations.
For Pi, approve project trust so the tracked extensions load.
For Grok, `--trust` or `/hooks-trust` enables project hooks.
Oh My Pi discovers `.omp/extensions/` from this directory; do not also load them with `-e`.
Codex, OpenCode, Cursor, and Antigravity are also supported primaries; exact launch, configuration, and trust requirements live in the [configuration guide](docs/configuration.md).
Additional verified worker-only harnesses use the same generated engineering policy.

The default backend is tmux.
See the setup and limits for [tmux](docs/tmux-backend.md), [Herdr](docs/herdr-backend.md), [Zellij](docs/zellij-backend.md), [Orca](docs/orca-backend.md), [cmux](docs/cmux-backend.md), [Paseo](docs/paseo-backend.md), [Rex](docs/rex-backend.md), [T3 Code](docs/t3code-backend.md), and [Tern](docs/tern-backend.md).
[Remote project coordinators](docs/remote-secondmates.md) are optional.

Start with a concrete request, for example: “Register my project and fix its flaky login test.”
The coordinator returns the fix and a reviewable PR, not an unexplained progress stream.
No command named `spudrunner` is invented: launch your existing coding harness inside the repository.

## Conversation commands

| Command | Purpose | Compatible old name |
| --- | --- | --- |
| `/status-summary` | Current work, decisions, completed results, and what is next; supports `file` and `include PRs`. | `/bearings` |
| `/session-recap` | Visible session outcomes and unanswered decisions. | `/ahoy` |
| `/updatespudrunner` | Guardedly update from this fork's origin and restart supported sessions. | `/updatefirstmate` |
| `/afk` | Away supervision and a return summary. | Unchanged |
| `/quiet` | Quiet supervision while you remain present; `/quiet off` exits. | Unchanged |
| `/stow` | Curate durable knowledge and this session's open work before a reset. | Unchanged |

Use the harness's native skill syntax where it differs from slash commands.
`/calm` changes supported transcript presentation only; see [current behavior and limits](docs/calm.md).
Pi's `/supervision-model` uses the eligible model catalog and thinking levels reported by Pi; see [configuration](docs/configuration.md).

## Configuration and maintenance

[Configuration](docs/configuration.md) owns `FM_HOME`, private paths, dispatch profiles, harness/backend selection, project delivery modes, and optional integrations.
Existing configuration filenames and keys remain unchanged.
Keep `.env`, `data/`, `state/`, `config/`, and `projects/` private.
[Optional Relay](docs/configuration.md) and [voice relay](docs/voice-relay.md) retain their existing opt-in and external-action boundaries.

[Fork maintenance](docs/fork-maintenance.md) explains publication selection, read-only original-upstream consumption, source upgrades, and reversible rollback.
Contributions target [hyAndrewLee/spudrunner](https://github.com/hyAndrewLee/spudrunner), not the original upstream by default.
A fork is not permission to publish: existing lineage and scoped-consent checks remain in force.

## Reference

- [Architecture](docs/architecture.md) and [integration ownership](docs/workflow-integration.md).
- [Supervisor contract](AGENTS.md), [script reference](docs/scripts.md), and [contributing](CONTRIBUTING.md).
- [Documentation audiences](docs/documentation-audiences.md) and [runtime verification](docs/verification/runtime-backends.md).
- [Monitoring continuity](docs/watcher-continuity.md), [turn-end protection](docs/turnend-guard.md), and [alert setup](docs/wedge-alarm.md).
- [Extension bindings](docs/extension-bindings.md) and the [Codex App boundary](docs/codex-app-backend.md).

Agent-runtime skills live in `.agents/skills/`; standalone installer-facing skills live in `skills/`.
Do not install the internal operating skills into unrelated repositories as standalone products.

## Attribution and license

Forked from Firstmate, Copyright 2026 Kun Chen, under the [MIT license](LICENSE).
Selected Poteto material is Copyright 2026 Lauren Tan, MIT.
Selected Caveman material is Copyright 2026 Julius Brussee, Apache-2.0 with historical MIT notices retained.
See the [source manifest and modification record](docs/workflow-sources.md) for exact scope, revisions, hashes, and license files.
Original names in source provenance, historical verification, and compatibility identifiers are intentional, not a claim of zero legacy strings.
