# 🚀 Arch & CachyOS Linux Setup Kit

A personal collection of scripts and configuration files for a fast, consistent post-installation setup on **Arch Linux** and **CachyOS**.

---

## ✨ Features

- **⚡ Automated Installation:** Interactive scripts to install packages from the official repos and the AUR using either `paru` or `yay`.
- **🐧 Two Distros:** Separate `arch/` and `cachyOs/` kits with the same structure but distro-tuned package lists. See [`PACKAGE_DIFF.md`](PACKAGE_DIFF.md) for what differs and why.
- **🔧 Editable Package Lists:** All packages live in plain text files under each distro's `packages/` folder — add or remove a package by editing a single line, no scripting needed.
- **🎨 Post-Installation Configuration:** The shared `config/` directory holds drop-in configs for `fastfetch`, `starship`, and a working `.bashrc`.
- **🗂️ Organized Guides:** The shared `toolv2/` directory groups command references by topic for faster lookup.
- **📖 Manual Setup Guide:** Each distro folder ships a `manual_setup.txt` documenting every manual step, organized into numbered sections.

---

## 📦 What's Inside?

```text
.
├── arch/                    — Arch Linux setup kit
│   ├── setup_paru.sh        — installer using paru
│   ├── setup_yay.sh         — installer using yay
│   ├── manual_setup.txt     — step-by-step manual reference (33 sections)
│   └── packages/
│       ├── pacman.txt       — official repo packages
│       ├── aur.txt          — AUR packages
│       └── uninstall.txt    — packages to remove (bloat / replaced apps)
├── cachyOs/                 — CachyOS setup kit (same layout)
│   ├── setup_paru.sh
│   ├── setup_yay.sh
│   ├── manual_setup.txt     — CachyOS-adapted manual reference (35 sections)
│   └── packages/{pacman,aur,uninstall}.txt
├── config/                  — shared drop-in configuration
│   ├── .bashrc              — working bash config (starship, pyenv, nvm, flutter)
│   ├── fastfetch/           — system-info display configs, presets, assets
│   └── starship.toml        — terminal prompt config
├── toolv2/                  — shared topic-grouped command references
│   ├── apps/                — flathub, ollama, xampp, vscode extensions, ytDown
│   ├── desktop/             — battery (CPU/thermal), ai_local, fastfetch, …
│   ├── runtime/             — paru, bash, node, python, anaconda
│   └── system/              — ethernet, fonts, gdm, grub
└── PACKAGE_DIFF.md          — arch vs cachyOs package diff + rationale
```

---

## 📝 How to Use

**1. Clone the repository**

```bash
git clone https://github.com/Bishwajit-2810/arch_setup
cd arch_setup
```

**2. Pick your distro folder**

```bash
cd arch        # on Arch Linux
# or
cd cachyOs     # on CachyOS
```

**3. Edit package lists** _(optional)_

Open any file under `packages/` and add or remove packages before running. Lines starting with `#` are treated as comments and ignored.

```text
packages/pacman.txt    — official repo packages
packages/aur.txt       — AUR packages
packages/uninstall.txt — packages to uninstall
```

**4. Make the script executable and run it**

Choose either `paru` or `yay` as your AUR helper:

```bash
chmod u+x setup_paru.sh && ./setup_paru.sh
# or
chmod u+x setup_yay.sh && ./setup_yay.sh
```

On Arch the AUR helper is installed automatically if missing. On CachyOS both `paru` and `yay` are already available from the repos / pre-installed.

**5. Follow the menu**

```text
1) Install official (pacman) packages
2) Install AUR packages
3) Uninstall packages
4) Dry run (preview)
5) Exit
```

---

## 🆚 Arch vs CachyOS

The two kits share the same scripts and almost the same package lists. The differences exist because CachyOS:

- ships `paru`/`yay` pre-installed and enables the CachyOS + Chaotic-AUR binary repos by default;
- provides its own `cachyos-*` packages (keyring, mirrorlist, settings, kernel manager, `cachy-browser`, …);
- handles GPU drivers with `chwd` instead of `nvidia-inst`, and ranks mirrors with `cachyos-rate-mirrors`;
- defaults to the optimized `linux-cachyos` kernel.

Every added/removed package and the reasoning is documented in [`PACKAGE_DIFF.md`](PACKAGE_DIFF.md).

---

## ⚠️ Important Notes

- Always run **option 4 (dry run)** first to preview all changes before applying them.
- The scripts require `sudo` privileges.
- Some packages need extra steps after install — check the distro's `manual_setup.txt` and the shared `toolv2/` references.
- **CachyOS:** never add `cachyos-*` meta packages to `uninstall.txt` — removing them breaks the curated setup.

**Happy Arching!** 😄
