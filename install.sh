#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_TARGET="$HOME"

echo "==> Caelestia Environment Installer <=="

# 1. Stow Dotfiles
echo "==> Stowing hypr, foot, ghostty, quickshell configs..."
for pkg in hypr foot ghostty quickshell; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    stow -v -t "$CONFIG_TARGET" -d "$DOTFILES_DIR" "$pkg"
  else
    echo "Warning: stow package '$pkg' not found in $DOTFILES_DIR"
  fi
done

# 2. Build & Install Caelestia Shell
echo ""
read -p "Would you like to install dependencies and build Caelestia Shell from '$DOTFILES_DIR/shell'? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Detect AUR helper
  AUR_HELPER=""
  if command -v paru &> /dev/null; then
    AUR_HELPER="paru"
  elif command -v yay &> /dev/null; then
    AUR_HELPER="yay"
  fi

  if [ -z "$AUR_HELPER" ]; then
    echo "Error: No AUR helper (paru or yay) found. Cannot automatically install AUR dependencies."
    echo "Please install paru or yay first, or manually install dependencies before running this."
    exit 1
  fi

  echo "==> Detected AUR helper: $AUR_HELPER"
  echo "==> Installing shell build and runtime dependencies..."
  
  DEPS=(
    cmake ninja pkg-config
    ddcutil brightnessctl app2unit libcava networkmanager lm_sensors
    fish aubio pipewire qt6-base qt6-declarative swappy
    libqalculate ttf-material-symbols-variable ttf-cascadia-code-nerd
    quickshell-git caelestia-cli hyprland-git
  )
  
  $AUR_HELPER -Sy --needed --noconfirm "${DEPS[@]}"

  # Compile and install shell
  echo "==> Building caelestia-shell from source..."
  cd "$DOTFILES_DIR/shell"
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
  cmake --build build
  
  echo "==> Installing caelestia-shell (requires sudo)..."
  sudo cmake --install build
  
  echo "==> caelestia-shell successfully installed."
  cd "$DOTFILES_DIR"
fi

echo "==> Done. Verify with: ls -la ~/.config/hypr ~/.config/foot ~/.config/ghostty"
