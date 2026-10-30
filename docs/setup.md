# Fresh-machine setup

The setup command provisions an Ubuntu/Debian machine (including WSL) or a macOS machine with Homebrew already installed.
It installs Pi, Claude Code, Codex, tmux, Herdr, Treehouse, the coordinator's npm tools, no-mistakes, and development linters.
Other supported harnesses and optional integrations remain opt-in; this is not an installer for every vendor listed in the adapter catalog.

With Git installed, run:

```sh
git clone https://github.com/hyAndrewLee/spudrunner.git "$HOME/spudrunner" && bash "$HOME/spudrunner/bin/setup.sh"
```

For an existing checkout, use `bash bin/setup.sh` from its root.
Use `bash bin/setup.sh --dry-run` to preview without downloading, installing, or writing configuration.
The script's `--help` is the owner of options, defaults, installation destinations, and side effects.
For example, `bash bin/setup.sh --harnesses pi,codex --backend herdr` selects a smaller harness set and a Herdr home.
The repository is cloned directly from your `hyAndrewLee/spudrunner` repository; setup does not create a fork or publish any changes.

## Login and launch

After setup, follow the printed commands:

```sh
source "$HOME/.config/spudrunner/env.sh"
gh auth login
cd "$HOME/spudrunner"
pi
```

Sign into Claude Code and Codex separately through their own interactive login flows when you use them.
Approve project trust when prompted so the bundled adapters and skills can load.
To launch after opening another terminal, source the same environment file first, or add that source line to your shell configuration yourself.
Choose the harness and models inside the harness; setup never chooses an account, requests credentials, or launches a paid model call.

## Safety and limits

Linux setup uses apt and may prompt for sudo; macOS uses the existing Homebrew installation.
Native Windows, non-apt Linux, and automatic Homebrew installation are not supported.
Node 22 or newer is required; an older or absent Node is supplemented with an official user-local Node 22 build whose download is verified against the release's SHA-256 manifest.
Missing npm packages are installed into a dedicated user-local prefix, not with `sudo npm`.
Existing commands are reused rather than silently upgraded; run the coordinator's installation check to diagnose outdated versions after upgrades.
The existing checksum-pinned installers own the Treehouse, Herdr, ShellCheck, and actionlint downloads.
The no-mistakes installer and npm packages come from their official distribution channels and require network access.

Setup preserves existing private configuration and does not edit shell startup files, register global hooks, start background services, open sessions, or copy tokens and credential stores.
It initializes ignored home directories and writes the selected backend only when `config/backend` is absent.
Rerunning completes missing installations without resetting your home.
This does not migrate another machine's private backlog, projects, global extensions, skills, or credentials; the tracked project skills and adapters travel with this checkout.
For optional personal integrations and dispatch configuration, see [configuration](configuration.md).

Installer regression checks run through `bash bin/test-run.sh tests/setup.test.sh`.
They exercise dry-run safety, both platform plans, invalid input, installation failure handling, local environment paths, and preservation of existing private settings with isolated package-manager fixtures.
Those checks are not a claim of a real clean-macOS installation; platform CI and a clean-host installation remain separate evidence.
