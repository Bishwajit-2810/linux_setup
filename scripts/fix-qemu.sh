#!/usr/bin/env bash
# Clean QEMU/KVM reinstall + fix for the broken dtc-1.8.0-1 libfdt (missing fdt_setprop).
# Run with: sudo bash /tmp/fix-qemu.sh
set -euo pipefail

green(){ printf '\033[32m==> %s\033[0m\n' "$*"; }
warn(){  printf '\033[33m==> %s\033[0m\n' "$*"; }

[[ $EUID -eq 0 ]] || { echo "Run with sudo: sudo bash $0"; exit 1; }

# --- 1. Get a known-good dtc (1.7.2-5 exports fdt_setprop) and pin it -----------
DTC_PKG=/var/cache/pacman/pkg/dtc-1.7.2-5-x86_64.pkg.tar.zst
if [[ ! -f $DTC_PKG ]]; then
  green "Downloading known-good dtc-1.7.2-5 from Arch archive..."
  curl -L -o "$DTC_PKG"     https://archive.archlinux.org/packages/d/dtc/dtc-1.7.2-5-x86_64.pkg.tar.zst
  curl -L -o "$DTC_PKG.sig" https://archive.archlinux.org/packages/d/dtc/dtc-1.7.2-5-x86_64.pkg.tar.zst.sig
fi

green "Pinning dtc in /etc/pacman.conf so -Syu won't pull the broken 1.8.0 back..."
if ! grep -qE '^\s*IgnorePkg\s*=.*\bdtc\b' /etc/pacman.conf; then
  sed -i '/^\[options\]/a IgnorePkg = dtc' /etc/pacman.conf
fi

green "Installing/downgrading dtc 1.7.2-5..."
pacman -U --noconfirm "$DTC_PKG"

# --- 2. Clean reinstall of the QEMU / libvirt stack -----------------------------
green "Removing existing QEMU/virt stack (configs kept)..."
pacman -Rdd --noconfirm qemu-full qemu-desktop qemu-base qemu-common qemu-system-x86 2>/dev/null || true

green "Clean reinstall of QEMU + libvirt + virt-manager..."
pacman -S --needed --noconfirm \
  qemu-full libvirt virt-manager virt-viewer \
  dnsmasq iptables-nft edk2-ovmf swtpm

# --- 3. Services & groups -------------------------------------------------------
green "Enabling libvirtd and adding $SUDO_USER to libvirt/kvm groups..."
systemctl enable --now libvirtd.service
usermod -aG libvirt,kvm "${SUDO_USER:-$USER}" || true
systemctl restart libvirtd.service

# --- 4. Verify ------------------------------------------------------------------
green "VERIFICATION"
echo "- dtc:  $(pacman -Q dtc)"
echo "- fdt_setprop in libfdt: $(objdump -T /usr/lib/libfdt.so.1 | grep -wq fdt_setprop && echo PRESENT || echo MISSING)"
echo "- qemu: $(qemu-system-x86_64 --version | head -1)"
echo "- /dev/kvm: $(ls -l /dev/kvm)"
echo "- libvirt domain capabilities (kvm should appear):"
virsh -c qemu:///system domcapabilities 2>/dev/null | grep -iE '<domain>|kvm' | head -3 || true
echo "- networks:"
virsh -c qemu:///system net-list --all || true

green "Done. If 'kvm' now shows in libvirt and qemu prints a version with no symbol error, you're fixed."
warn  "Log out/in (or reboot) if you were just added to the libvirt/kvm groups."
warn  "When Arch ships a fixed dtc (>1.8.0-1), remove 'IgnorePkg = dtc' from /etc/pacman.conf and run: pacman -Syu"
