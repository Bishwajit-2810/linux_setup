# 📦 Package Diff — Arch vs CachyOS

This document explains how the package lists in `cachyOs/packages/` differ from `arch/packages/`, and **why** each package was added or removed.

CachyOS is Arch-based, so the two kits share the vast majority of their packages. The differences come down to four facts about CachyOS:

1. It ships its own **`cachyos-*` packages** (keyring, mirrorlists, settings, kernel tools, browser) that have no stock-Arch equivalent.
2. It enables the **CachyOS + Chaotic-AUR binary repos** by default, so several things that are AUR-only on Arch resolve straight from `pacman` (faster, no compile).
3. It ships **`paru`/`yay` pre-installed** and provides them as plain repo packages.
4. It defaults to the optimized **`linux-cachyos` kernel** and uses **`chwd`** for hardware/GPU driver detection.

> Counts: Arch `pacman.txt` 185 / CachyOS 197 · Arch `aur.txt` 32 / CachyOS 28 · `gnome.txt` 9 / 9 · `uninstall.txt` 14 / 15.
>
> **GNOME split (both distros):** the GNOME desktop, shell extensions, and GNOME-native apps/tools were pulled out of `pacman.txt`/`aur.txt` into a separate `gnome.txt`, installed via menu option 3. This split is identical on Arch and CachyOS, so it does **not** contribute to the arch-vs-cachy differences below.

---

## ➕ Added on CachyOS (`pacman.txt`)

These live in the CachyOS repositories and are not present on a stock Arch install.

| Package | Why it was added |
| --- | --- |
| `cachyos-keyring` | Trust keys for the CachyOS repos; required to verify CachyOS packages. Replaces the role `archlinux-keyring` alone plays on Arch. |
| `cachyos-mirrorlist` | Mirror list for the standard CachyOS repo. |
| `cachyos-v3-mirrorlist` | Mirror list for the x86-64-v3 optimized repo (the main reason to run CachyOS). |
| `cachyos-rate-mirrors` | Benchmarks and ranks CachyOS + Arch mirrors — the CachyOS replacement for `reflector`. |
| `cachyos-settings` | Curated sysctl/udev/zram/scheduler tuning that defines the "CachyOS feel". |
| `linux-cachyos` | Optimized default kernel (BORE scheduler, LTO). Replaces stock `linux`. |
| `linux-cachyos-headers` | Kernel headers matching `linux-cachyos`; needed for DKMS modules (NVIDIA, VirtualBox). Replaces `linux-headers`. |
| `cachyos-kernel-manager` | GUI to install/switch kernel variants (`-bore`, `-lto`, `-rt`, …). |
| `chwd` | CachyOS Hardware Detection — installs GPU/other drivers via `sudo chwd -a`. Replaces Arch's manual `nvidia-inst` flow. |
| `cachy-browser` | Hardened Firefox fork shipped by default on CachyOS. |
| `cachyos-fish-config` | Preconfigured fish shell setup (fish is the CachyOS default shell). |
| `cachyos-zsh-config` | Preconfigured zsh setup, for users who prefer zsh. |
| `fish` | Default interactive shell on CachyOS (Arch defaults to bash only). |
| `cachyos-hello` | Post-install welcome / configuration app. |
| `octopi` | Qt pacman/AUR GUI frontend bundled with CachyOS. |
| `paru` | AUR helper — a plain repo package on CachyOS (must be AUR-built on Arch). |

---

## ➖ Removed on CachyOS (`pacman.txt`)

These Arch entries were dropped because CachyOS supersedes or doesn't need them.

| Package | Why it was removed |
| --- | --- |
| `archlinux-keyring` | Pulled in as a dependency anyway; `cachyos-keyring` is the package you explicitly manage on CachyOS. (Still installed transitively — just not listed.) |
| `linux-headers` | Replaced by `linux-cachyos-headers` to match the CachyOS kernel. Installing stock `linux-headers` would mismatch the running kernel. |
| `pkgstats` | Arch-specific opt-in package statistics reporter; not relevant on CachyOS. |
| `hunspell-en_us` | Duplicate of `hunspell-en_US` (the correct casing) that existed in the Arch list; removed the redundant lowercase entry. |

---

## 🔁 Moved AUR → repo, or dropped (`aur.txt`)

On CachyOS these resolve from a binary repo (CachyOS or Chaotic-AUR) instead of being compiled from the AUR, so they were moved out of `aur.txt`. They are documented inline as comments at the bottom of `cachyOs/packages/aur.txt`.

| Package | What changed on CachyOS |
| --- | --- |
| `extension-manager` | Now in `gnome.txt` on both distros; available from the repos on CachyOS. |
| `proton-vpn-gtk-app` | Moved to `pacman.txt` — available from the repos. |
| `protontricks` | Moved to `pacman.txt`. |
| `lutris` | Moved to `pacman.txt`. |
| `preload` | Available from the CachyOS repo as `preload`; install via `pacman` (see manual setup §8) rather than the AUR. |

> The remaining AUR entries (`android-studio`, `visual-studio-code-bin`, `google-chrome`, `mongodb-bin`, `xampp`, `zoom`, etc.) are still AUR-only on both distros and are unchanged.

---

## 🐢 GNOME list (`gnome.txt`)

Identical on both distros (9 packages), installed via menu option 3 with the AUR helper since it mixes repo + AUR packages. This list is kept to packages genuinely tied to the **GNOME desktop** — not generic GTK apps:

- **Desktop & shell:** `gdm`, `gnome-browser-connector`, `gnome-menus`, `gnome-shell-extensions`, `gnome-tweaks`, `gnome-font-viewer`, `ptyxis`
- **GNOME apps & tools:** `extension-manager`, `gnome-boxes`

On CachyOS the GNOME edition already ships `gdm` + the GNOME shell, so `--needed` makes re-running this list harmless. Skip it on a non-GNOME desktop.

> Moved out to `aur.txt` as regular apps: `planify`, `parabolic`, `devtoolbox` (GTK4/libadwaita apps that run on any desktop), and `pencil` (Electron-based Pencil Project). They use GTK but aren't tied to the GNOME desktop.

---

## 🗑️ Uninstall list (`uninstall.txt`)

Mostly identical (default GNOME bloat / apps replaced by preferred alternatives). CachyOS adds two notes:

- `cachy-browser` is added as an **optional** removal for users who don't want the bundled browser.
- ⚠️ A guard comment warns **never** to add `cachyos-settings`, `cachyos-keyring`, or the `linux-cachyos*` meta/kernel packages here — removing them breaks the curated CachyOS configuration.

---

## 🧭 Distro-specific manual steps

Beyond packages, the CachyOS `manual_setup.txt` diverges from Arch in these sections:

| Topic | Arch | CachyOS |
| --- | --- | --- |
| AUR helper | build `paru` from AUR | already installed (`pacman -S paru`) |
| Mirrors | `reflector` | `sudo cachyos-rate-mirrors` |
| GPU drivers | `nvidia-inst` | `sudo chwd -a` |
| Kernel | stock `linux` | `linux-cachyos` + `cachyos-kernel-manager` |
| Default shell | bash | fish (`cachyos-fish-config`) |
| Gaming | per-app installs | `cachyos-gaming-meta` / `cachyos-gaming-applications` |

---

## 🔍 Regenerating this diff

To re-check the package differences after editing the lists:

```bash
clean() { grep -v '^\s*#' "$1" | grep -v '^\s*$' | awk '{print $1}' | sort -u; }

echo "Added on CachyOS:"
comm -23 <(clean cachyOs/packages/pacman.txt) <(clean arch/packages/pacman.txt)

echo "Removed on CachyOS:"
comm -13 <(clean cachyOs/packages/pacman.txt) <(clean arch/packages/pacman.txt)

echo "AUR entries only on Arch:"
comm -13 <(clean cachyOs/packages/aur.txt) <(clean arch/packages/aur.txt)
```
