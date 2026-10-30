#!/usr/bin/env bash
# setup.sh - provision a fresh Spudrunner machine (Ubuntu/Debian/WSL or macOS).
# Usage: bash bin/setup.sh [--dry-run] [--harnesses pi,claude,codex] [--backend tmux|herdr]
# Installs system prerequisites, Node 22+ when missing, the selected harnesses,
# coordinator tools, pinned Treehouse/Herdr, and pinned development linters.
# Defaults: Pi, Claude Code, Codex, and tmux. Herdr is installed with either backend.
# --dry-run prints commands without installing, downloading, or writing anything.
# Uses sudo only for apt; macOS requires an existing Homebrew installation.
# npm installs are user-local. Existing commands and private config are preserved.
# No logins, credentials, services, fleet sessions, or global hooks are configured.
# Run the printed source command before launching a harness in this checkout.
set -eu

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
DRY_RUN=0
HARNESSES=pi,claude,codex
BACKEND=tmux
usage() { head -n 12 "$0" | tail -n +2 | cut -c3-; }
die() { printf 'setup: %s\n' "$*" >&2; exit 1; }
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --harnesses|--backend)
      [ "$#" -ge 2 ] && [ -n "$2" ] || die "$1 needs a value"
      case "$1" in --harnesses) HARNESSES=$2 ;; --backend) BACKEND=$2 ;; esac
      shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done
case "$BACKEND" in tmux|herdr) ;; *) die "unsupported backend: $BACKEND" ;; esac
case "$HARNESSES" in ''|,*|*,|*,,*) die 'expected a comma-separated harness list' ;; esac
IFS=, read -ra SELECTED <<< "$HARNESSES"
for harness in "${SELECTED[@]}"; do
  case "$harness" in pi|claude|codex) ;; *) die "unsupported harness: $harness (choose pi,claude,codex)" ;; esac
done
OS=$(uname -s)
ARCH=$(uname -m)
case "$OS-$ARCH" in Linux-x86_64|Linux-aarch64|Linux-arm64|Darwin-x86_64|Darwin-arm64) ;; *) die "unsupported platform: $OS-$ARCH" ;; esac
case "$OS" in
  Linux) command -v apt-get >/dev/null || die 'Linux setup currently supports apt-based Ubuntu/Debian/WSL only' ;;
  Darwin) command -v brew >/dev/null || die 'install Homebrew from https://brew.sh, then rerun setup' ;;
esac

BIN="$HOME/.local/bin"
PREFIX="$HOME/.local/share/spudrunner/npm"
NODE_HOME="$HOME/.local/share/spudrunner/node"
ENV_FILE="$HOME/.config/spudrunner/env.sh"
# Keep already installed commands first; add user-local destinations for new ones.
export PATH="$PATH:$BIN:$PREFIX/bin:$NODE_HOME/bin"
run() {
  printf '+'
  printf ' %q' "$@"
  printf '\n'
  [ "$DRY_RUN" -eq 1 ] || "$@"
}
if [ "$OS" = Linux ]; then
  SUDO=()
  if [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null || die 'apt needs root or sudo'
    SUDO=(sudo)
  fi
  run "${SUDO[@]}" apt-get update
  run "${SUDO[@]}" apt-get install -y ca-certificates curl git jq python3 tmux gh build-essential
else
  run brew install git jq python tmux gh
fi

TMP=
cleanup() { [ -z "$TMP" ] || rm -rf -- "$TMP"; }
trap cleanup EXIT
# Install an official Node 22 build only when the existing runtime is too old.
# The archive name and digest come from nodejs.org's HTTPS release manifest.
node_major=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || true)
case "$node_major" in ''|*[!0-9]*) node_major=0 ;; esac
if [ "$node_major" -lt 22 ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '+ install official Node 22 for %s-%s (verify SHA-256 release manifest) in %s\n' "$OS" "$ARCH" "$NODE_HOME"
  else
    TMP=$(mktemp -d)
    case "$OS" in Linux) node_os=linux ;; Darwin) node_os=darwin ;; esac
    case "$ARCH" in x86_64) node_arch=x64 ;; *) node_arch=arm64 ;; esac
    curl -fLsS --retry 3 https://nodejs.org/dist/latest-v22.x/SHASUMS256.txt -o "$TMP/SHASUMS256.txt"
    entry=$(awk -v suffix="-$node_os-$node_arch.tar.gz" '$2 ~ (suffix "$") {print; exit}' "$TMP/SHASUMS256.txt")
    [ -n "$entry" ] || die 'Node release manifest has no matching archive'
    read -r digest archive <<< "$entry"
    case "$archive" in node-v22.*-"$node_os"-"$node_arch".tar.gz) ;; *) die 'invalid Node archive name' ;; esac
    curl -fLsS --retry 3 "https://nodejs.org/dist/latest-v22.x/$archive" -o "$TMP/$archive"
    if command -v sha256sum >/dev/null; then
      actual=$(sha256sum "$TMP/$archive" | awk '{print $1}')
    else
      actual=$(shasum -a 256 "$TMP/$archive" | awk '{print $1}')
    fi
    [ "$actual" = "$digest" ] || die 'Node archive checksum mismatch'
    mkdir -p "$NODE_HOME"
    tar -xzf "$TMP/$archive" --strip-components=1 -C "$NODE_HOME"
    export PATH="$NODE_HOME/bin:$PATH"
  fi
fi
export PATH="$NODE_HOME/bin:$BIN:$PREFIX/bin:$PATH"
run mkdir -p "$BIN" "$PREFIX"
install_npm() { # <command> <package>
  if command -v "$1" >/dev/null 2>&1; then
    printf 'present: %s\n' "$1"
  else
    run npm install --global --prefix "$PREFIX" "$2"
  fi
}
for harness in "${SELECTED[@]}"; do
  case "$harness" in
    pi) install_npm pi @earendil-works/pi-coding-agent ;;
    claude) install_npm claude @anthropic-ai/claude-code ;;
    codex) install_npm codex @openai/codex ;;
  esac
done
for tool in gh-axi chrome-devtools-axi lavish-axi tasks-axi quota-axi; do
  install_npm "$tool" "$tool"
done
for tool in treehouse herdr shellcheck actionlint; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf 'present: %s\n' "$tool"
  else
    run bash "$ROOT/bin/install-$tool.sh" "$BIN"
  fi
done
if ! command -v no-mistakes >/dev/null 2>&1; then
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '+ download and run the official no-mistakes installer (user-local)\n'
  else
    [ -n "$TMP" ] || TMP=$(mktemp -d)
    curl -fLsS --retry 3 https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh -o "$TMP/no-mistakes.sh"
    NO_MISTAKES_LINK_DIR="$BIN" sh "$TMP/no-mistakes.sh"
  fi
fi
if [ "$DRY_RUN" -eq 0 ]; then
  mkdir -p "$(dirname "$ENV_FILE")" "$ROOT/config" "$ROOT/data" "$ROOT/state" "$ROOT/projects"
  # Bash and Zsh can both source this file; do not edit the user's shell rc files.
  # shellcheck disable=SC2016 # PATH expands when the generated file is sourced.
  printf 'export PATH=%q:%q:%q:"$PATH"\n' "$NODE_HOME/bin" "$BIN" "$PREFIX/bin" > "$ENV_FILE"
  if [ ! -e "$ROOT/config/backend" ]; then
    printf '%s\n' "$BACKEND" > "$ROOT/config/backend"
  else
    printf 'preserved: config/backend (requested backend applies to new homes only)\n'
  fi
  for harness in "${SELECTED[@]}"; do
    command -v "$harness" >/dev/null || die "$harness did not install successfully"
  done
fi
printf '\nSetup %s. Next:\n  source %q\n  gh auth login\n  cd %q\n  %s\n' \
  "$([ "$DRY_RUN" -eq 1 ] && printf plan || printf complete)" "$ENV_FILE" "$ROOT" "${SELECTED[0]}"
printf 'Sign into each selected harness using its own login flow. Approve project trust when prompted.\n'
printf 'Bundled project skills and adapters load from this checkout; no personal credentials or global agent settings are copied.\n'
