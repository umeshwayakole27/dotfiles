#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_TARGET="$HOME"

echo "==> Stowing hypr, foot, ghostty..."
for pkg in hypr foot ghostty; do
  stow -v -t "$CONFIG_TARGET" -d "$DOTFILES_DIR" "$pkg"
done

echo "==> Done. Verify with: ls -la ~/.config/hypr ~/.config/foot ~/.config/ghostty"
