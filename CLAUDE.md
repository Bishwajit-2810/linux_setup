# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal Linux post-installation toolkit covering two Arch-based distributions. The repo is split into one folder per distro — `arch/` and `cachyOs/` — each containing parallel setup scripts (one using `yay`, one using `paru`), plain-text package lists, and a manual-setup reference. Shared terminal/desktop configuration lives at the repo root in `config/` and `toolv2/`.

CachyOS is Arch-based, so the two distro folders are intentionally near-identical in structure; they differ only in their package lists and a handful of distro-specific steps. See `PACKAGE_DIFF.md` for the exact package mismatches and the rationale behind each add/remove.

## Repository Layout

```text
.
├── arch/                  — Arch Linux setup kit
│   ├── setup_yay.sh       — installer using yay
│   ├── setup_paru.sh      — installer using paru
│   ├── manual_setup.txt   — 33-section manual reference
│   └── packages/{pacman,aur,gnome,uninstall}.txt
├── cachyOs/               — CachyOS setup kit (same structure)
│   ├── setup_yay.sh
│   ├── setup_paru.sh
│   ├── manual_setup.txt   — 35-section manual reference, CachyOS-adapted
│   └── packages/{pacman,aur,gnome,uninstall}.txt
├── config/                — shared drop-in config (.bashrc, starship, fastfetch)
├── toolv2/                — shared topic-grouped command references
└── PACKAGE_DIFF.md        — arch vs cachyOs package differences + rationale
```

## Running the Setup Scripts

```bash
cd arch      # or: cd cachyOs
bash setup_yay.sh    # then choose option 4 (dry run) to preview
bash setup_paru.sh

chmod +x setup_yay.sh && ./setup_yay.sh
```

The interactive menu offers: install pacman packages, install AUR packages, install GNOME packages, uninstall packages, dry run, exit. Both scripts read their package lists from the sibling `packages/` directory (`$SCRIPT_DIR/packages`), so they must be run from inside their own distro folder.

## Architecture

**Per-distro folders** — `arch/` and `cachyOs/` each hold two parallel scripts (`setup_yay.sh`, `setup_paru.sh`) that are functionally identical except for the AUR helper used (`yay` vs `paru`). Package lists (`packages/pacman.txt`, `packages/aur.txt`, `packages/gnome.txt`, `packages/uninstall.txt`) are plain text — one package per line, `#` comments and blank lines ignored — and are the primary thing to edit when adding/removing packages.

**GNOME packages are split out** — packages genuinely tied to the GNOME *desktop* (the shell, `gdm`, extensions, `gnome-tweaks`, `extension-manager`, `gnome-boxes`) live in `packages/gnome.txt` (not in `pacman.txt`/`aur.txt`), installed via menu option 3. Because that list mixes official-repo and AUR packages, `install_gnome_packages` always uses the AUR helper (`yay`/`paru` handle both). Skip it on a non-GNOME desktop. Keep the scope tight: generic GTK4/libadwaita apps (e.g. `planify`, `parabolic`, `devtoolbox`) run on any desktop and belong in `aur.txt`, not here — only add a package to `gnome.txt` if it requires or only makes sense under the GNOME desktop.

**arch vs cachyOs differences** — keep the two folders structurally in sync; only the package lists and distro-specific manual steps should diverge. The CachyOS scripts differ from Arch in two ways: the header reads "CACHYOS LINUX SETUP KIT", and `install_yay`/`install_paru` try `pacman -S` first (both helpers ship in the CachyOS repo / come pre-installed) before falling back to an AUR build. The CachyOS manual reference swaps in `chwd` for GPU drivers, `cachyos-rate-mirrors` for mirror ranking, and the `linux-cachyos` kernel. Whenever you change a package in one distro, decide whether it should change in the other and update `PACKAGE_DIFF.md`.

**`config/`** (shared, repo root) — Drop-in configuration files meant to be copied to their target locations:

- `config/.bashrc` → `~/.bashrc` (starship init, pyenv, nvm, flutter PATH, LM Studio CLI)
- `config/starship.toml` → `~/.config/starship.toml`
- `config/fastfetch/` → `~/.config/fastfetch/` (includes presets and ASCII art assets)

**`toolv2/`** (shared, repo root) — Plain-text command references regrouped by category: `apps/`, `desktop/`, `runtime/`, `system/`. Use these when looking up by topic.

**`manual_setup.txt`** (one per distro folder) — The canonical manual setup reference: `arch/` has 33 numbered sections (network → AUR helper → drivers → services → fonts → display → IDEs → runtimes → apps → AI → virt → DBs → misc) plus service-status and maintenance appendices; `cachyOs/` mirrors it with 35 sections and CachyOS-specific notes. Not meant to be executed top-to-bottom — pick the sections that apply.

## Key Conventions

- Both scripts use `set -euo pipefail` — any failure exits immediately.
- Logging helpers `log()`, `warn()`, `error()`, `info()` use ANSI colors (green/yellow/red/cyan).
- Duplicate entries may exist in the package arrays intentionally (idempotent due to `--needed` flag in pacman/paru/yay).
- Commented-out AUR packages (e.g. `#vscodium-bin`) mark packages known to have issues or intentionally skipped.
- The `uninstall.txt` list targets bloat/replaced packages from a default install. On CachyOS, never list `cachyos-*` meta packages there — removing them breaks the curated setup.

## `.bashrc` Configuration

Canonical working copy lives at `config/.bashrc`. Key exports to be aware of when working on Flutter or Python tooling:

- Flutter: `export PATH="$PATH:$HOME/.softwares/flutter/bin"`
- Chrome for Flutter: `export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable`
- pyenv init hooks required for Python version switching
- nvm sourced via `/usr/share/nvm/init-nvm.sh`
- LM Studio CLI: `export PATH="$PATH:$HOME/.lmstudio/bin"`
- Flutter pub binaries: `export PATH="$PATH:$HOME/.pub-cache/bin"`

Older topic notes live in `toolv2/runtime/bash.txt`.
