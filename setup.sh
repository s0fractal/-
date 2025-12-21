#!/bin/bash

# s0fractal Environment Bootstrapper
# Version: Sovereign v1.0

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
echo "🔮 Initializing s0fractal Universe..."

# ==========================================
# 1. SHELL DETECTION & ALIASES
# ==========================================
TARGET_RC=""
ALIAS_CMD=""
SHELL_NAME=""

if [ -f "$HOME/.zshrc" ]; then
    TARGET_RC="$HOME/.zshrc"
    SHELL_NAME="zsh"
    # Zsh supports noglob for 'λ ?' magic
    ALIAS_CMD="alias λ='noglob $REPO_ROOT/sh/lambda.sh'" 
elif [ -f "$HOME/.bashrc" ]; then
    TARGET_RC="$HOME/.bashrc"
    SHELL_NAME="bash"
    ALIAS_CMD="alias λ='$REPO_ROOT/sh/lambda.sh'"
fi

echo "🔍 Shell detected: $SHELL_NAME ($TARGET_RC)"

# Inject λ alias
if [ -n "$TARGET_RC" ]; then
    if ! grep -q "alias λ=" "$TARGET_RC"; then
        echo "" >> "$TARGET_RC"
        echo "# s0fractal Lambda Protocol" >> "$TARGET_RC"
        echo "$ALIAS_CMD" >> "$TARGET_RC"
        echo "✅ λ-Protocol injected."
    else
        echo "✓ λ-Protocol already active."
    fi
fi

# Git Global Configs
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.sync "!git pull && git submodule update --init --recursive"
git config --global alias.nuke "!git clean -fd && git reset --hard"

# ==========================================
# 2. INFRASTRUCTURE (SOVEREIGN BREW)
# ==========================================
BREW_DIR="$HOME/homebrew"
BREW_BIN="$BREW_DIR/bin/brew"
CRYSTAL_BREWFILE="$REPO_ROOT/glyphs/crystal/software.rb"

echo "🏗  Checking Infrastructure..."

# 2.1 Check or Install Homebrew
if [ ! -x "$BREW_BIN" ]; then
    echo "📦 Sovereign Brew NOT found. Cloning into $BREW_DIR..."
    git clone https://github.com/Homebrew/brew "$BREW_DIR"
    
    echo "⚡ Activating Brew for this session..."
    eval "$($BREW_BIN shellenv)"
    
    # Inject into Shell Config
    if [ -n "$TARGET_RC" ]; then
        if ! grep -q "homebrew/bin/brew shellenv" "$TARGET_RC"; then
            echo "" >> "$TARGET_RC"
            echo "# s0fractal Sovereign Brew" >> "$TARGET_RC"
            echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> "$TARGET_RC"
            echo "✅ Brew path injected into $TARGET_RC"
        fi
    fi
    
    echo "🔄 Updating Brew formulas (first run)..."
    $BREW_BIN update --force --quiet
else
    echo "✓ Sovereign Brew detected."
    # Ensure it's active in current script context
    eval "$($BREW_BIN shellenv)"
fi

# 2.2 Install Dependencies from Crystal
if [ -f "$CRYSTAL_BREWFILE" ]; then
    echo "💎 Found Crystal definition: software.rb"
    echo "📦 Installing/Updating dependencies..."
    # щоб не створювати зайвий Brewfile.lock.json у гліфах, якщо не хочеш
    $BREW_BIN bundle install --file="$CRYSTAL_BREWFILE"
    echo "✅ Software synced."
else
    echo "ℹ️  No software crystal found in glyphs/."
fi

# ==========================================
# 3. INTERFACE (ZELLIJ)
# ==========================================
ZELLIJ_CONF_DIR="$HOME/.config/zellij"
REPO_ZELLIJ="$REPO_ROOT/sh/configs/zellij"

if [ -d "$REPO_ZELLIJ" ]; then
    echo "🎨 Syncing Interface (Zellij)..."
    mkdir -p "$ZELLIJ_CONF_DIR/layouts"
    ln -sf "$REPO_ZELLIJ/config.kdl" "$ZELLIJ_CONF_DIR/config.kdl"
    ln -sf "$REPO_ZELLIJ/s0.kdl" "$ZELLIJ_CONF_DIR/layouts/s0.kdl"
    echo "✅ Layouts linked."
fi

# ==========================================
# 4. NERVOUS SYSTEM (HOOKS)
# ==========================================
HOOK_DIR="../.git/hooks"
if [ -d "$HOOK_DIR" ]; then
    # post-checkout
    echo "#!/bin/sh" > "$HOOK_DIR/post-checkout"
    echo "exec < /dev/tty" >> "$HOOK_DIR/post-checkout"
    echo "git submodule update --init --recursive" >> "$HOOK_DIR/post-checkout"
    chmod +x "$HOOK_DIR/post-checkout"
    
    # post-merge (щоб після pull теж оновлювались сабмодулі)
    cp "$HOOK_DIR/post-checkout" "$HOOK_DIR/post-merge"
    
    echo "✅ Hooks installed (Auto-sync)."
fi

echo "🚀 s0fractal system operational."
