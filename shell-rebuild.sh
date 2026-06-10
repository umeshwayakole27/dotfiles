#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SHELL_DIR="$DOTFILES_DIR/shell"

echo "==> Rebuilding Caelestia Shell from source..."
cd "$SHELL_DIR"

if [ ! -d "build" ]; then
  echo "==> Initializing CMake build directory..."
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
fi

echo "==> Compiling Caelestia Shell..."
cmake --build build

echo "==> Installing Caelestia Shell (requires sudo)..."
sudo cmake --install build

echo "==> Rebuild and installation complete!"
