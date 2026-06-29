#!/bin/bash
set -e

REPO_DIR="$(dirname "$0")"

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"

info()    { echo -e "${CYAN}${BOLD}==> $1${RESET}"; }
success() { echo -e "${GREEN}  ✔ $1${RESET}"; }

info "Backing up dotfiles..."
for file in .zshrc .zprofile .p10k.zsh .gitconfig; do
  cp "$HOME/$file" "$REPO_DIR/dotfiles/$file"
  success "$file"
done

info "Backing up config files..."
cp "$HOME/.config/git/ignore" "$REPO_DIR/config/git/ignore"
cp "$HOME/.config/karabiner/karabiner.json" "$REPO_DIR/config/karabiner/karabiner.json"
cp "$HOME/.config/gh/config.yml" "$REPO_DIR/config/gh/config.yml"
success "git/ignore, karabiner.json, gh/config.yml"

info "Backing up iTerm2 settings..."
plutil -convert xml1 "$HOME/Library/Preferences/com.googlecode.iterm2.plist" \
  -o "$REPO_DIR/config/iterm2/com.googlecode.iterm2.plist"
success "com.googlecode.iterm2.plist"

info "Backing up VSCode settings..."
cp "$HOME/Library/Application Support/Code/User/settings.json" "$REPO_DIR/vscode/settings.json"
code --list-extensions > "$REPO_DIR/vscode/extensions.txt"
success "settings.json, extensions.txt"

info "Backing up Claude Code settings..."
cp "$HOME/.claude/settings.json" "$REPO_DIR/config/claude/settings.json"
success "claude/settings.json"

info "Backing up Antigravity extensions..."
python3 -c "
import json
with open('$HOME/.antigravity-ide/extensions/extensions.json') as f:
    exts = json.load(f)
print('\n'.join(e['identifier']['id'] for e in exts))
" > "$REPO_DIR/config/antigravity/extensions.txt"
success "antigravity/extensions.txt"

info "Updating Brewfile..."
brew bundle dump --file="$REPO_DIR/Brewfile" --force
success "Brewfile"

echo ""
echo -e "${GREEN}${BOLD}Backup complete!${RESET}"
echo -e "Review changes with ${CYAN}git diff${RESET}, then commit."
