# Arch Linux — Manual Setup Reference

Companion to the `setup_paru.sh` / `setup_yay.sh` installers. The scripts handle
bulk package installs from `packages/*.txt`; this file documents the manual
steps, service enables, edits, and configuration that the scripts do not do.

Order below roughly matches the order to run them on a fresh install.
For a topic-grouped view of the same commands, see [`tools/`](tools/) and [`toolv2/`](toolv2/).

---

## Table of Contents

1. [Network — PPPoE](#1-network--pppoe-daffodilnet)
2. [AUR Helper — paru](#2-aur-helper--paru)
3. [System Update + Core Utilities](#3-system-update--core-utilities)
4. [GPU — NVIDIA](#4-gpu--nvidia)
5. [Bluetooth](#5-bluetooth)
6. [Firewall — UFW](#6-firewall--ufw)
7. [System Optimization](#7-system-optimization)
8. [Fonts](#8-fonts)
9. [Wayland / GDM Session](#9-wayland--gdm-session)
10. [GRUB — Hide Boot Menu](#10-grub--hide-boot-menu)
11. [Dual Boot — Detect Other OSes](#11-dual-boot--detect-other-oses)
12. [Multimedia & Codecs](#12-multimedia--codecs)
13. [Office / Productivity](#13-office--productivity)
14. [Browsers](#14-browsers)
15. [Creative / Media Apps](#15-creative--media-apps)
16. [IDEs / Editors](#16-ides--editors)
17. [Terminal / Shell](#17-terminal--shell)
18. [Runtime — Node.js via nvm](#18-runtime--nodejs-via-nvm)
19. [Runtime — Python via pyenv](#19-runtime--python-via-pyenv)
20. [Runtime — Anaconda + Qt6 on Wayland](#20-runtime--anaconda--qt6-on-wayland)
21. [Flutter](#21-flutter)
22. [Chat / Media Apps](#22-chat--media-apps)
23. [Flatpak / Flathub](#23-flatpak--flathub)
24. [GNOME Extensions & Theming](#24-gnome-extensions--theming)
25. [AI / LLM — Ollama + GPU](#25-ai--llm--ollama--gpu)
26. [AI — Open-WebUI / Fooocus](#26-ai--open-webui--fooocus)
27. [Virtualization — qemu / libvirt](#27-virtualization--qemu--libvirt)
28. [XAMPP (LAMP Stack)](#28-xampp-lamp-stack)
29. [MySQL (Standalone)](#29-mysql-standalone--after-stopping-xampp)
30. [MongoDB](#30-mongodb)
31. [Graphic Tablet — Huion Inspiroy Dial 2](#31-graphic-tablet--huion-inspiroy-dial-2)
32. [YouTube DL Helper (VDH coapp)](#32-youtube-dl-helper-vdh-coapp)
33. [Uninstall Default GNOME Bloat](#33-uninstall-default-gnome-bloat)

- [Appendix A — System Services Quick Status](#appendix-a--system-services-quick-status)
- [Appendix B — Maintenance](#appendix-b--maintenance)

---

## 1. Network — PPPoE (Daffodilnet)

```bash
sudo pacman -S rp-pppoe

nmcli con edit type pppoe con-name "err"
set pppoe.username user@daffodilnet.com
save
yes
quit
```

## 2. AUR Helper — paru

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

## 3. System Update + Core Utilities

```bash
sudo pacman -Syyu
sudo pacman -S --needed base-devel
sudo pacman -S archlinux-keyring
sudo pacman -S nano vim git neofetch fastfetch htop bpytop bat curl wget unzip \
    zip xz unrar tar p7zip rsync ntfs-3g exfat-utils bzip2 cmake gcc make clang \
    cargo go nodejs linux-headers samba bleachbit nvtop cpufetch jdk-openjdk \
    intel-ucode
```

## 4. GPU — NVIDIA

> Skip if you don't have an NVIDIA card.

```bash
sudo pacman -S nvidia-inst
nvidia-inst
```

## 5. Bluetooth

```bash
sudo pacman -S --needed bluez bluez-utils
# sudo pacman -S blueman
sudo systemctl enable --now bluetooth
```

## 6. Firewall — UFW

```bash
sudo pacman -S ufw
sudo systemctl enable --now ufw
```

## 7. System Optimization

**Preload** — caches frequently used apps:

```bash
paru -S preload
sudo systemctl enable --now preload
```

**Touch gestures:**

```bash
paru -S touchegg
sudo systemctl enable --now touchegg.service
```

**CPU frequency / thermal:**

```bash
sudo pacman -S cpupower lm_sensors thermald stress
sudo cpupower frequency-set -g performance
sudo systemctl enable --now cpupower.service
sudo systemctl enable --now thermald
```

Edit `/etc/default/cpupower` and set `governor='performance'`.

**auto-cpufreq** (laptop battery tuning):

```bash
paru -S auto-cpufreq
sudo auto-cpufreq --install
auto-cpufreq --stats
```

## 8. Fonts

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    ttf-dejavu ttf-liberation ttf-roboto ttf-bitstream-vera ttf-droid \
    ttf-ubuntu-font-family ttf-anonymous-pro adobe-source-sans-pro-fonts \
    gnome-font-viewer
paru -S ttf-google-sans ttf-google ttf-ms-fonts

# Bangla fonts
git clone https://github.com/fahadahammed/linux-bangla-fonts.git

# Bangla input
paru -S ibus-avro-git
```

## 9. Wayland / GDM Session

```bash
sudo nano /etc/gdm/custom.conf
```

Add:

```
WaylandEnable=true
DefaultSession=gnome
```

Verify:

```bash
echo $XDG_SESSION_TYPE   # should print: wayland
```

## 10. GRUB — Hide Boot Menu

```bash
sudo nano /etc/default/grub
```

Set:

```
GRUB_TIMEOUT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_HIDDEN_TIMEOUT=0
```

Then:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

## 11. Dual Boot — Detect Other OSes

```bash
sudo pacman -S os-prober
sudo os-prober
sudo update-grub
```

If `update-grub` is missing, create it:

```bash
sudo nano /usr/sbin/update-grub
```

```sh
#!/bin/sh
set -e
exec grub-mkconfig -o /boot/grub/grub.cfg "$@"
```

```bash
sudo chown root:root /usr/sbin/update-grub
sudo chmod 755 /usr/sbin/update-grub
sudo update-grub
```

## 12. Multimedia & Codecs

```bash
sudo pacman -S vlc mpv gst-plugins-good gst-libav gstreamer-vaapi \
    a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 \
    libtheora libvorbis libxv wavpack x264 xvidcore
```

## 13. Office / Productivity

```bash
sudo pacman -S libreoffice-fresh thunderbird
sudo pacman -S enchant mythes-en hunspell-en_US aspell-en languagetool libmythes
paru -S onlyoffice-bin
```

## 14. Browsers

```bash
sudo pacman -S firefox chromium
paru -S google-chrome
```

## 15. Creative / Media Apps

```bash
sudo pacman -S gimp krita inkscape kdenlive obs-studio guvcview
paru -S lorien-bin
```

## 16. IDEs / Editors

```bash
sudo pacman -S neovim
sudo pacman -S intellij-idea-community-edition pycharm-community-edition
paru -S visual-studio-code-bin vscodium android-studio postman-bin
```

VS Codium — install a `.vsix` from corporate marketplace:

```bash
codium --install-extension /path/to/extension.vsix --profile bk
```

## 17. Terminal / Shell

```bash
sudo pacman -S starship bash-completion
```

Add to `~/.bashrc`:

```bash
eval "$(starship init bash)"
fastfetch

export PATH="$PATH:$HOME/.softwares/flutter/bin"
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

source /usr/share/nvm/init-nvm.sh

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
```

Custom fastfetch theme assets:

```bash
cd ~/.local/share
git clone https://github.com/LierB/fastfetch
```

## 18. Runtime — Node.js via nvm

```bash
sudo pacman -S nvm
# .bashrc:  source /usr/share/nvm/init-nvm.sh

nvm install 12
nvm install 19
nvm install 23
nvm install 24.2.0
nvm use 24.2.0
```

## 19. Runtime — Python via pyenv

```bash
sudo pacman -S pyenv
```

`~/.bashrc`:

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
```

```bash
pyenv install 3.11.11
pyenv local 3.11.11

python -m venv venv_name
source venv_name/bin/activate
```

## 20. Runtime — Anaconda + Qt6 on Wayland

```bash
source /opt/anaconda/bin/activate root
sudo pacman -S qt6-base qt6-wayland

conda create -n qt6env python=3.11
conda activate qt6env
conda install -c conda-forge pyqt
pip install PyQt6
```

`~/.bashrc`:

```bash
export QT_QPA_PLATFORM=wayland
export QT_PLUGIN_PATH=/usr/lib/qt6/plugins
export LD_LIBRARY_PATH=/usr/lib/qt6:$LD_LIBRARY_PATH
```

Quick test:

```python
from PyQt6.QtWidgets import QApplication, QLabel
app = QApplication([])
QLabel("Hello from Wayland!").show()
app.exec()
```

## 21. Flutter

```bash
sudo pacman -S curl git unzip zip xz glu ninja
```

Place the Flutter SDK in `~/.softwares/flutter`, then add to `~/.bashrc`:

```bash
export PATH="$PATH:$HOME/.softwares/flutter/bin"
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
```

```bash
flutter doctor --android-licenses
```

## 22. Chat / Media Apps

```bash
sudo pacman -S discord telegram-desktop qbittorrent
paru -S spotify-launcher stremio
```

## 23. Flatpak / Flathub

```bash
sudo pacman -S flatpak

flatpak install flathub com.mattjakeman.ExtensionManager
flatpak install flathub com.github.tenderowl.frog
flatpak install flathub com.mongodb.Compass
flatpak install flathub com.stremio.Stremio
flatpak install flathub me.dusansimic.DynamicWallpaper
```

## 24. GNOME Extensions & Theming

```bash
sudo pacman -S gnome-browser-connector
paru -S gnome-shell-extensions gnome-menus \
    gnome-shell-extension-openweather \
    dynamic-wallpaper
paru -S stacer-bin
sudo pacman -S grub-customizer
```

## 25. AI / LLM — Ollama + GPU

```bash
sudo pacman -S rocm-hip-sdk        # AMD
sudo pacman -S ollama-cuda         # NVIDIA
paru -S cuda

sudo systemctl enable --now ollama.service

ollama run deepseek-r1
ollama run gemma3
ollama run qwen3
ollama run llama3.2
ollama run llama3.1
ollama run mistral
ollama run llava
```

LM Studio (GUI):

```bash
paru -S lmstudio-appimage
```

## 26. AI — Open-WebUI / Fooocus

`open-webui` via pip:

```bash
pip install open-webui
open-webui serve
pip install --upgrade open-webui
```

Run from saved venvs:

```bash
source .AI/WebUI/webui_env/bin/activate
open-webui serve

source .AI/Fooocus/fooocus_env/bin/activate
python .AI/Fooocus/entry_with_update.py
```

## 27. Virtualization — qemu / libvirt

```bash
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils vde2 \
    openbsd-netcat
sudo systemctl enable --now libvirtd.service
sudo virsh net-start default
sudo virsh net-autostart default
```

## 28. XAMPP (LAMP Stack)

```bash
paru -S xampp

sudo nano /etc/systemd/system/xampp.service
```

```ini
[Unit]
Description=XAMPP

[Service]
ExecStart=/opt/lampp/xampp start
ExecStop=/opt/lampp/xampp stop
Type=forking

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable --now xampp.service

# XAMPP MySQL shell
/opt/lampp/bin/mysql -u root -p
```

DB files live in `/opt/lampp/var/mysql`.

## 29. MySQL (Standalone — after stopping XAMPP)

```bash
sudo pacman -S mysql mysql-workbench
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mysqld
```

## 30. MongoDB

```bash
paru -S mongodb-bin mongodb-compass-bin
sudo systemctl enable --now mongodb
```

## 31. Graphic Tablet — Huion Inspiroy Dial 2

Driver download:
<https://www.huion.com/index.php?m=content&c=index&a=lists&catid=16&down_title2=Inspiroy%20Dial%202>

## 32. YouTube DL Helper (VDH coapp)

```bash
curl -sSLf https://github.com/aclap-dev/vdhcoapp/releases/latest/download/install.sh | bash
```

## 33. Uninstall Default GNOME Bloat

```bash
paru -Rns epiphany
```

Full uninstall list: [`packages/uninstall.txt`](packages/uninstall.txt).

---

## Appendix A — System Services Quick Status

```bash
sudo systemctl status bluetooth
sudo systemctl status ufw
sudo systemctl status preload
sudo systemctl status touchegg.service
sudo systemctl status libvirtd.service
sudo systemctl status xampp.service
sudo systemctl status mongodb
sudo systemctl status ollama.service
sudo systemctl status mysqld
sudo systemctl status thermald
sudo systemctl status cpupower.service
```

## Appendix B — Maintenance

```bash
# Disk usage of paru / pacman caches
du -sh ~/.cache/paru/clone/ /var/cache/pacman/pkg/

# Clean caches
paru -Sccd

# Full system upgrade
paru -Syyu
```
