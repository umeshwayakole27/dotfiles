# Caelestia Dotfiles & Shell: AI Agent Guidelines

Welcome, Agent. This file serves as the system instruction and single source of truth for working within this workspace. Read this carefully before performing any modifications, adding packages, or building/syncing the shell.

---

## 📂 Workspace Architecture

The workspace consists of two independent git repositories:
1. **Dotfiles Repository (`~/dotfiles`)**:
   * Root repository. Manages system configurations using GNU Stow.
   * Remote `origin`: `https://github.com/umeshwayakole27/dotfiles`
2. **Caelestia Shell Repository (`~/dotfiles/shell`)**:
   * Subdirectory, but a **completely separate Git repository** (gitignored from the root dotfiles repository).
   * A custom fork of `caelestia-dots/shell`.
   * Remote `origin`: `https://github.com/umeshwayakole27/shell`
   * Remote `upstream`: `https://github.com/caelestia-dots/shell.git`

> [!CRITICAL]
> Do NOT create a monorepo. Never add the `shell/` directory to the root `dotfiles` Git index. Keep them as two separate repositories.

---

## 🛠️ GNU Stow Guidelines

We use GNU Stow to manage configurations. The target directories are mapped to `$HOME` (e.g. `~`).

1. **Package Convention**:
   All stow packages must follow the pattern: `~/dotfiles/<package>/.config/<app>/`
   Example: `hypr` package is located at `~/dotfiles/hypr/.config/hypr/`.
2. **Deploying configs**:
   Config packages are stowed using:
   ```bash
   stow -v -t ~ -d ~/dotfiles <package>
   ```
3. **Safety Rule**:
   Never overwrite or delete existing directories/files inside `~/.config` without asking the user. If a directory already exists (e.g., `~/.config/ghostty`), Stow will safely merge symlinks into it.

---

## 📦 Managing Dependencies

If a task requires adding packages, utilities, or library dependencies:
1. **Document**: Update the list in [docs/dependencies.md](file:///home/umesh/dotfiles/docs/dependencies.md).
2. **Automate**: Add the package name to the `DEPS` array inside [install.sh](file:///home/umesh/dotfiles/install.sh).
3. **Convention**: Use **`hyprland-git`** instead of `hyprland` for compositor dependencies.
4. **AUR Helpers**: The user's system runs Arch Linux with `paru` and `yay` installed. The installation script automatically detects and uses them.

---

## 💻 Rebuilding & Modifying Caelestia Shell

The shell is built using CMake and Ninja. If you make modifications to the QML or C++ files under `shell/`:
1. **Do not compile manually**: Use the helper script [shell-rebuild.sh](file:///home/umesh/dotfiles/shell-rebuild.sh) at the root of `~/dotfiles`.
2. **Execution**:
   ```bash
   ./shell-rebuild.sh
   ```
   *Note: This script will run CMake, compile using Ninja, and run `sudo cmake --install` to deploy files.*

---

## 🔄 Syncing Caelestia Shell Upstream

To sync the user's shell fork with the official `caelestia-dots/shell` repository:
1. **Sync commands**:
   ```bash
   cd ~/dotfiles/shell
   git fetch upstream
   git checkout main
   git rebase upstream/main
   # Inform the user if they need to push the updates to their fork
   ```
2. **Upstream Documentation**: Read [upstream-sync.md](file:///home/umesh/dotfiles/shell/docs/upstream-sync.md) for more details.

---

## 🔐 Credentials & Remote Push Operations

AI agents operating in this terminal session do not have git credentials cached or interactive access to pass private keys / tokens.
* **Rule**: Configure remotes and commit changes locally. Do NOT attempt to push to remote origins if it blocks on authentication. Instead, log the exact `git push` commands for the user to run manually.
