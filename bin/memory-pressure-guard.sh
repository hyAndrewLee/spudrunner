#!/usr/bin/env bash
# memory-pressure-guard.sh - Wrapper for Jev Multi-Agent Memory RSS & Swap Thrashing Guard (Pattern 46)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec python3 "$SCRIPT_DIR/memory-pressure-guard.py" "$@"
