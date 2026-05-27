#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/packages"

# ── Colors & Styles ────────────────────────────────────────────────────────────
R="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
GRAY="\033[0;90m"

# ── Logging ────────────────────────────────────────────────────────────────────
log()   { echo -e "${GREEN}  ✔  ${BOLD}$*${R}"; }
warn()  { echo -e "${YELLOW}  ⚠  $*${R}"; }
error() { echo -e "${RED}  ✘  ${BOLD}$*${R}" >&2; }
info()  { echo -e "${CYAN}  ›  $*${R}"; }

# ── Helpers ────────────────────────────────────────────────────────────────────
load_packages() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    error "Package file not found: $file"
    exit 1
  fi
  grep -v '^\s*#' "$file" | grep -v '^\s*$' | awk '{print $1}'
}

pkg_count() { load_packages "$1" | wc -l | tr -d ' '; }

divider() { echo -e "${GRAY}  ────────────────────────────────────────────────${R}"; }

# ── Header ─────────────────────────────────────────────────────────────────────
print_header() {
  clear
  echo
  echo -e "${BOLD}${BLUE}  ╔══════════════════════════════════════════════╗${R}"
  echo -e "${BOLD}${BLUE}  ║${R}                                              ${BOLD}${BLUE}║${R}"
  echo -e "${BOLD}${BLUE}  ║${R}  ${BOLD}${WHITE}         ARCH LINUX SETUP KIT             ${R}  ${BOLD}${BLUE}║${R}"
  echo -e "${BOLD}${BLUE}  ║${R}  ${DIM}${GRAY}          AUR helper  ›  yay              ${R}  ${BOLD}${BLUE}║${R}"
  echo -e "${BOLD}${BLUE}  ║${R}                                              ${BOLD}${BLUE}║${R}"
  echo -e "${BOLD}${BLUE}  ╚══════════════════════════════════════════════╝${R}"
  echo
}

# ── Menu ───────────────────────────────────────────────────────────────────────
main_menu() {
  print_header

  local n_pacman n_aur n_remove
  n_pacman=$(pkg_count "$PKG_DIR/pacman.txt")
  n_aur=$(pkg_count "$PKG_DIR/aur.txt")
  n_remove=$(pkg_count "$PKG_DIR/uninstall.txt")

  echo -e "${BOLD}${WHITE}  Packages${R}"
  echo -e "  ${GRAY}pacman.txt${R}    ${CYAN}${n_pacman} packages${R}"
  echo -e "  ${GRAY}aur.txt${R}       ${CYAN}${n_aur} packages${R}"
  echo -e "  ${GRAY}uninstall.txt${R} ${CYAN}${n_remove} packages${R}"
  echo
  divider
  echo
  echo -e "  ${BOLD}${GREEN} 1${R}  ${WHITE}Install pacman packages${R}     ${DIM}${GRAY}[${n_pacman}]${R}"
  echo -e "  ${BOLD}${GREEN} 2${R}  ${WHITE}Install AUR packages${R}        ${DIM}${GRAY}[${n_aur}]${R}"
  echo -e "  ${BOLD}${YELLOW} 3${R}  ${WHITE}Uninstall packages${R}          ${DIM}${GRAY}[${n_remove}]${R}"
  echo -e "  ${BOLD}${CYAN} 4${R}  ${WHITE}Dry run preview${R}"
  echo -e "  ${BOLD}${RED} 5${R}  ${WHITE}Exit${R}"
  echo
  divider
  echo
  echo -ne "  ${BOLD}Choose [1-5]:${R} "
  read -r choice
  echo

  case "$choice" in
    1) install_pacman_packages ;;
    2) install_yay; install_aur_packages ;;
    3) install_yay; uninstall_packages ;;
    4) show_dry_run ;;
    5) echo -e "  ${CYAN}Goodbye!${R}\n"; exit 0 ;;
    *) error "Invalid option — please choose 1 to 5." ;;
  esac

  echo
  echo -ne "  ${DIM}Press Enter to return to the menu...${R}"
  read -r
  main_menu
}

# ── Actions ────────────────────────────────────────────────────────────────────
check_sudo() {
  if ! sudo -v; then
    error "Sudo access is required."
    exit 1
  fi
}

install_yay() {
  if ! command -v yay &>/dev/null; then
    warn "yay not found — installing..."
    echo
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf /tmp/yay
    log "yay installed."
    echo
  fi
}

install_pacman_packages() {
  local -a pkgs
  mapfile -t pkgs < <(load_packages "$PKG_DIR/pacman.txt")
  echo
  echo -e "${BOLD}${BLUE}  ┌─ Installing pacman packages ────────────────────┐${R}"
  echo -e "${BOLD}${BLUE}  │${R}  ${CYAN}${#pkgs[@]} packages  ›  sudo pacman -Syu${R}             ${BOLD}${BLUE}│${R}"
  echo -e "${BOLD}${BLUE}  └─────────────────────────────────────────────────┘${R}"
  echo
  sudo pacman -Syu --needed --noconfirm "${pkgs[@]}"
  echo
  log "Pacman packages installed successfully."
}

install_aur_packages() {
  local -a pkgs
  mapfile -t pkgs < <(load_packages "$PKG_DIR/aur.txt")
  echo
  echo -e "${BOLD}${BLUE}  ┌─ Installing AUR packages ───────────────────────┐${R}"
  echo -e "${BOLD}${BLUE}  │${R}  ${CYAN}${#pkgs[@]} packages  ›  yay -S${R}                       ${BOLD}${BLUE}│${R}"
  echo -e "${BOLD}${BLUE}  └─────────────────────────────────────────────────┘${R}"
  echo
  yay -S --needed --noconfirm "${pkgs[@]}"
  echo
  log "AUR packages installed successfully."
}

uninstall_packages() {
  local -a pkgs
  mapfile -t pkgs < <(load_packages "$PKG_DIR/uninstall.txt")
  echo
  echo -e "${BOLD}${YELLOW}  ┌─ Uninstalling packages ─────────────────────────┐${R}"
  echo -e "${BOLD}${YELLOW}  │${R}  ${CYAN}${#pkgs[@]} packages  ›  yay -R${R}                       ${BOLD}${YELLOW}│${R}"
  echo -e "${BOLD}${YELLOW}  └─────────────────────────────────────────────────┘${R}"
  echo
  yay -R --noconfirm "${pkgs[@]}"
  echo
  log "Packages removed successfully."
}

show_dry_run() {
  echo
  echo -e "${BOLD}${CYAN}  ┌─ Dry Run Preview ───────────────────────────────┐${R}"
  echo -e "${BOLD}${CYAN}  │${R}  No changes will be made.                        ${BOLD}${CYAN}│${R}"
  echo -e "${BOLD}${CYAN}  └─────────────────────────────────────────────────┘${R}"

  echo
  echo -e "  ${BOLD}${GREEN}Pacman packages${R}  ${GRAY}($(pkg_count "$PKG_DIR/pacman.txt"))${R}"
  divider
  load_packages "$PKG_DIR/pacman.txt" | pr -3 -t -w 80 | sed 's/^/  /'

  echo
  echo -e "  ${BOLD}${CYAN}AUR packages${R}  ${GRAY}($(pkg_count "$PKG_DIR/aur.txt"))${R}"
  divider
  load_packages "$PKG_DIR/aur.txt" | pr -2 -t -w 80 | sed 's/^/  /'

  echo
  echo -e "  ${BOLD}${YELLOW}Packages to uninstall${R}  ${GRAY}($(pkg_count "$PKG_DIR/uninstall.txt"))${R}"
  divider
  load_packages "$PKG_DIR/uninstall.txt" | sed 's/^/  /'
  echo
}

# ── Entry ──────────────────────────────────────────────────────────────────────
check_sudo
install_yay
main_menu
