#!/bin/bash

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"

info()    { echo -e "${CYAN}${BOLD}==> $1${RESET}"; }
success() { echo -e "${GREEN}  ✔ $1${RESET}"; }

info "Applying Dock settings..."
defaults write com.apple.dock tilesize -int 39
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true
killall Dock
success "Dock configured (size=39, no recent apps, minimize to app icon)"

echo ""
echo -e "${GREEN}${BOLD}Done!${RESET}"
