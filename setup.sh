#!/bin/bash
# s0fractal Sovereign Setup v1.5 (Copy-on-Select Enabled)

# --- TRIANGULATION ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🔮 Tuning s0fractal Universe..."

# ==========================================
# 1. ZELLIJ CONFIG (Explicit Clipboard)
# ==========================================
ZELLIJ_CONF_DIR="$HOME/.config/zellij"
REPO_ZELLIJ="$REPO_ROOT/sh/configs/zellij"

echo "🎨 Configuring Interface..."
mkdir -p "$REPO_ZELLIJ"

# Генеруємо конфіг з COPY ON SELECT
cat << KDL > "$REPO_ZELLIJ/config.kdl"
// s0fractal config
theme "gruvbox-dark"
default_layout "s0"
mouse_mode true
copy_on_select true 

// MacOS Clipboard Fix
copy_command "pbcopy"
KDL

# Лінкуємо
if [ -d "$ZELLIJ_CONF_DIR" ]; then
    mkdir -p "$ZELLIJ_CONF_DIR/layouts"
    ln -sf "$REPO_ZELLIJ/config.kdl" "$ZELLIJ_CONF_DIR/config.kdl"
    ln -sf "$REPO_ZELLIJ/s0.kdl" "$ZELLIJ_CONF_DIR/layouts/s0.kdl"
    echo "✅ Zellij config updated (copy_on_select = true)."
fi

# ==========================================
# 2. ZSHRC INJECTION (Safe Autostart)
# ==========================================
TARGET_RC="$HOME/.zshrc"

if [ -f "$TARGET_RC" ]; then
    # 1. Brew (має бути першим)
    if ! grep -q "homebrew/bin/brew shellenv" "$TARGET_RC"; then
        echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> "$TARGET_RC"
    fi

    # 2. Alias
    if ! grep -q "alias λ=" "$TARGET_RC"; then
        echo "alias λ='noglob $REPO_ROOT/sh/lambda.sh'" >> "$TARGET_RC"
    fi

    # 3. HUD (перед Zellij)
    HUD_CMD="$REPO_ROOT/sh/hud.sh"
    if ! grep -q "sh/hud.sh" "$TARGET_RC"; then
        echo "[ -f \"$HUD_CMD\" ] && \"$HUD_CMD\"" >> "$TARGET_RC"
    fi

    # 4. Zellij Auto-Start (З затримкою для буфера)
    if ! grep -q "ZELLIJ_AUTO_ATTACH" "$TARGET_RC"; then
        echo "" >> "$TARGET_RC"
        echo "# s0fractal Auto-Cockpit" >> "$TARGET_RC"
        echo 'if [[ -z "$ZELLIJ" ]]; then' >> "$TARGET_RC"
        echo '    export ZELLIJ_AUTO_ATTACH=true' >> "$TARGET_RC"
        echo '    # Wait for macOS pasteboard service to wake up' >> "$TARGET_RC"
        echo '    # sleep 0.1' >> "$TARGET_RC" 
        echo '    if command -v zellij >/dev/null; then' >> "$TARGET_RC"
        echo '        exec zellij --layout s0' >> "$TARGET_RC"
        echo '    fi' >> "$TARGET_RC"
        echo 'fi' >> "$TARGET_RC"
        echo "✅ Auto-start logic injected."
    fi
fi

# ==========================================
# 3. GLOBAL GIT CONFIG
# ==========================================
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.sync "!git pull && git submodule update --init --recursive"

echo "🚀 Ready. Restart terminal."