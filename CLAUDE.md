# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal Arch Linux post-installation toolkit. It contains two parallel setup scripts (one using `yay`, one using `paru` as the AUR helper), configuration files for terminal tools, and text-based reference guides for manual setup tasks.

## Running the Setup Scripts

```bash
# Preview what will be installed/removed (always do this first)
bash setup_yay.sh   # then choose option 4 (dry run)
bash setup_paru.sh  # then choose option 4 (dry run)

# Make executable and run interactively
chmod +x setup_yay.sh && ./setup_yay.sh
chmod +x setup_paru.sh && ./setup_paru.sh
```

The interactive menu offers: install pacman packages, install AUR packages, uninstall packages, dry run, exit.

## Architecture

**Two parallel scripts** — `setup_yay.sh` and `setup_paru.sh` are functionally identical except for the AUR helper used (`yay` vs `paru`). Both auto-install their respective AUR helper if missing, then present the same interactive menu. Package lists (`PACMAN_PACKAGES`, `AUR_PACKAGES`, `UNINSTALL_PACKAGES`) are defined as bash arrays at the top of each file and are the primary thing to edit when adding/removing packages.

**`config/`** — Drop-in configuration files meant to be copied to their target locations:

- `config/.bashrc` → `~/.bashrc` (starship init, pyenv, nvm, flutter PATH, LM Studio CLI)
- `config/starship.toml` → `~/.config/starship.toml`
- `config/fastfetch/` → `~/.config/fastfetch/` (includes presets and ASCII art assets)

**`tools/`** — Plain-text command references for specific setup tasks (not scripts — commands are meant to be run manually). Each file covers one topic: bluetooth, grub, ollama, pyenv, nvm, XAMPP, fonts, etc.

**`toolv2/`** — Same content as `tools/`, regrouped by category: `apps/`, `desktop/`, `runtime/`, `system/`. Use these when looking up by topic; both copies should be kept in sync.

**`manual_setup.md` / `manual_setup.txt`** — The canonical manual setup reference, structured into 33 numbered sections (network → AUR helper → drivers → services → fonts → display → IDEs → runtimes → apps → AI → virt → DBs → misc) plus appendices for service status and maintenance. The two files mirror each other; update both when editing. Not meant to be executed top-to-bottom — pick the sections that apply.

## Key Conventions

- Both scripts use `set -euo pipefail` — any failure exits immediately.
- Logging helpers `log()`, `warn()`, `error()` use ANSI colors (green/yellow/red).
- Duplicate entries exist in the package arrays intentionally (idempotent due to `--needed` flag in pacman/paru/yay).
- Commented-out AUR packages (e.g. `#devtoolbox`) mark packages known to have issues.
- The `UNINSTALL_PACKAGES` list targets bloat/replaced packages from a default GNOME install.

## `.bashrc` Configuration

Canonical working copy lives at `config/.bashrc`. Key exports to be aware of when working on Flutter or Python tooling:

- Flutter: `export PATH="$PATH:$HOME/.softwares/flutter/bin"`
- Chrome for Flutter: `export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable`
- pyenv init hooks required for Python version switching
- nvm sourced via `/usr/share/nvm/init-nvm.sh`
- LM Studio CLI: `export PATH="$PATH:$HOME/.lmstudio/bin"`
- Flutter pub binaries: `export PATH="$PATH:$HOME/.pub-cache/bin"`

Older topic notes live in `tools/bash.txt` and `toolv2/runtime/bash.txt`.
