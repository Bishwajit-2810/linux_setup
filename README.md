# 🚀 Arch Linux Setup Kit

A personal collection of scripts and configuration files for a fast, consistent Arch Linux setup.

---

## ✨ Features

- **⚡ Automated Installation:** Interactive scripts to install packages from the official Arch repos and the AUR using either `paru` or `yay`.
- **🔧 Editable Package Lists:** All packages live in plain text files under `packages/` — add or remove a package by editing a single line, no scripting needed.
- **🎨 Post-Installation Configuration:** The `config/` directory holds drop-in configurations for `fastfetch`, `starship`, and a working `.bashrc`.
- **📚 Utility Guides:** The `tools/` directory contains command references for setting up specific software (GRUB, Ollama, XAMPP, pyenv, etc.).
- **🗂️ Organized Guides:** The `toolv2/` directory groups the same reference notes by topic with an index for faster lookup.
- **📖 Manual Setup Guide:** `manual_setup.md` (and the mirrored `manual_setup.txt`) document every manual step taken during installation, organized into numbered sections.

---

## 📦 What's Inside?

```
.
├── setup_paru.sh          — Installer script using paru as the AUR helper
├── setup_yay.sh           — Installer script using yay as the AUR helper
├── manual_setup.md        — Step-by-step manual setup reference (Markdown)
├── manual_setup.txt       — Same content as manual_setup.md, plain text
├── packages/
│   ├── pacman.txt         — Official repo packages (grouped by category)
│   ├── aur.txt            — AUR packages (grouped by category)
│   └── uninstall.txt      — Packages to remove (GNOME bloat / replaced apps)
├── config/
│   ├── .bashrc            — Working bash config (starship, pyenv, nvm, flutter)
│   ├── fastfetch/         — System info display configs, presets, and assets
│   └── starship.toml      — Terminal prompt config
├── tools/
│   ├── grub.txt           — Bootloader configuration
│   ├── ollama.txt         — Local LLM setup
│   ├── python versions.txt — Python version management (pyenv)
│   └── ...                — Many more guides
└── toolv2/                — Organized copy of the same guides, grouped by topic
    ├── apps/              — flathub, ollama, xampp, vscode extensions, ytDown
    ├── desktop/           — battery (CPU/thermal), ai_local, fastfetch, graphicPad, system_status
    ├── runtime/           — paru, bash, node, python, anaconda
    └── system/            — ethernet, fonts, gdm, grub
```

---

## 📝 How to Use

**1. Clone the repository**

```bash
git clone https://github.com/Bishwajit-2810/arch_setup
cd arch_setup
```

**2. Edit package lists** _(optional)_

Open any file under `packages/` and add or remove packages before running. Lines starting with `#` are treated as comments and ignored.

```
packages/pacman.txt   — official repo packages
packages/aur.txt      — AUR packages
packages/uninstall.txt — packages to uninstall
```

**3. Make the script executable and run it**

Choose either `paru` or `yay` as your AUR helper:

```bash
chmod u+x setup_paru.sh && ./setup_paru.sh
# or
chmod u+x setup_yay.sh && ./setup_yay.sh
```

The AUR helper will be installed automatically if it is not already present.

**4. Follow the menu**

```
1) Install official (pacman) packages
2) Install AUR packages
3) Uninstall packages
4) Dry run (preview)
5) Exit
```

---

## ⚠️ Important Notes

- Always run **option 4 (dry run)** first to preview all changes before applying them.
- The scripts require `sudo` privileges.
- Some packages need extra steps after install — check the `tools/` directory for specific instructions.

**Happy Arching!** 😄
