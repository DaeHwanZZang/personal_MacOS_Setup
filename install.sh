#!/bin/bash
set -e

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"

info()    { echo -e "${CYAN}${BOLD}==> $1${RESET}"; }
success() { echo -e "${GREEN}  ✔ $1${RESET}"; }
warn()    { echo -e "${YELLOW}  ⚠ $1${RESET}"; }
error()   { echo -e "${RED}  ✘ $1${RESET}"; exit 1; }

info "Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
success "Homebrew ready"

info "Installing packages from Brewfile..."
brew bundle --file="$(dirname "$0")/Brewfile"
success "Packages installed"

info "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "Oh My Zsh installed"
else
  warn "Oh My Zsh already exists, skipping"
fi

info "Linking dotfiles..."
DOTFILES_DIR="$(dirname "$0")/dotfiles"
for file in .zshrc .zprofile .p10k.zsh .gitconfig; do
  src="$DOTFILES_DIR/$file"
  dst="$HOME/$file"
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    warn "Backed up existing $file → $file.bak"
  fi
  ln -sf "$src" "$dst"
  success "Linked $file"
done

info "Linking config files..."
mkdir -p "$HOME/.config/git" "$HOME/.config/karabiner" "$HOME/.config/gh"
ln -sf "$(dirname "$0")/config/git/ignore" "$HOME/.config/git/ignore"
ln -sf "$(dirname "$0")/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ln -sf "$(dirname "$0")/config/gh/config.yml" "$HOME/.config/gh/config.yml"
success "Config files linked"

info "Linking VSCode settings..."
VSCODE_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_DIR"
ln -sf "$(dirname "$0")/vscode/settings.json" "$VSCODE_DIR/settings.json"
success "VSCode settings linked"

info "Restoring Claude Code settings..."
mkdir -p "$HOME/.claude"
cp "$(dirname "$0")/config/claude/settings.json" "$HOME/.claude/settings.json"
success "Claude Code settings restored"

info "Installing Antigravity extensions..."
if command -v agy &>/dev/null; then
  while IFS= read -r ext; do
    agy --install-extension "$ext" && success "$ext"
  done < "$(dirname "$0")/config/antigravity/extensions.txt"
else
  warn "agy CLI not found, skipping Antigravity extensions"
fi

info "Restoring iTerm2 settings..."
ITERM2_PLIST="$(dirname "$0")/config/iterm2/com.googlecode.iterm2.plist"
if [ -f "$ITERM2_PLIST" ]; then
  cp "$ITERM2_PLIST" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  success "iTerm2 settings restored (restart iTerm2 to apply)"
else
  warn "iTerm2 plist not found, skipping"
fi

info "Applying macOS settings..."
"$(dirname "$0")/macos.sh"

echo ""
echo -e "${GREEN}${BOLD}All done!${RESET} Restart your terminal to apply changes."
echo -e "Run ${CYAN}p10k configure${RESET} to set up Powerlevel10k if needed."
