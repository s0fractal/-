#!/bin/bash
# s0fractal Sovereign Setup v1.6 (The Vault)

# --- TRIANGULATION ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🔮 Tuning s0fractal Universe..."

# ==========================================
# 1. THE VAULT (Secrets Management)
# ==========================================
VAULT_FILE="$HOME/.s0_vault"

if [ ! -f "$VAULT_FILE" ]; then
    echo "🔒 Creating Secure Vault at $VAULT_FILE..."
    touch "$VAULT_FILE"
    chmod 600 "$VAULT_FILE" # Тільки власник може читати
    
    # Template
    cat << EOF > "$VAULT_FILE"
# s0fractal Secret Vault
# 🛑 DO NOT COMMIT THIS FILE OR SHARE IT
# Loaded automatically by .zshrc

# --- AI Models ---
# export GEMINI_API_KEY="your_key_here"
# export OPENAI_API_KEY="your_key_here"
# export ANTHROPIC_API_KEY="your_key_here"

# --- Tools ---
# export GITHUB_TOKEN="if_needed_manual_override"
EOF
    echo "✅ Vault template created."
else
    echo "✓ Vault exists."
    # Enforce security just in case
    chmod 600 "$VAULT_FILE"
fi

# ==========================================
# 2. ZSHRC INJECTION
# ==========================================
TARGET_RC="$HOME/.zshrc"

if [ -f "$TARGET_RC" ]; then
    # 1. Brew
    if ! grep -q "homebrew/bin/brew shellenv" "$TARGET_RC"; then
        echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> "$TARGET_RC"
    fi

    # 2. The Vault (Найважливіше - на початку, щоб змінні були доступні всім)
    if ! grep -q "s0_vault" "$TARGET_RC"; then
        echo "source $VAULT_FILE" >> "$TARGET_RC"
        echo "✅ Vault linked to shell."
    fi

    # 3. Alias
    if ! grep -q "alias λ=" "$TARGET_RC"; then
        echo "alias λ='noglob $REPO_ROOT/sh/lambda.sh'" >> "$TARGET_RC"
    fi

    # 4. HUD
    HUD_CMD="$REPO_ROOT/sh/hud.sh"
    if ! grep -q "sh/hud.sh" "$TARGET_RC"; then
        echo "[ -f \"$HUD_CMD\" ] && \"$HUD_CMD\"" >> "$TARGET_RC"
    fi

    # 5. Zellij Auto-Start
    if ! grep -q "ZELLIJ_AUTO_ATTACH" "$TARGET_RC"; then
        echo 'if [[ -z "$ZELLIJ" ]]; then' >> "$TARGET_RC"
        echo '    export ZELLIJ_AUTO_ATTACH=true' >> "$TARGET_RC"
        echo '    if command -v zellij >/dev/null; then' >> "$TARGET_RC"
        echo '        exec zellij --layout s0' >> "$TARGET_RC"
        echo '    fi' >> "$TARGET_RC"
        echo 'fi' >> "$TARGET_RC"
    fi
fi

# ... решта без змін (Git config, Zellij config) ...
# (Для економії місця я не дублюю весь файл, але ти знаєш, що там було)
# Якщо копіюєш повністю - не забудь додати блоки Git Config та Zellij Config з попередньої версії!

# --- GIT CONFIG ---
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.sync "!git pull && git submodule update --init --recursive"

# --- ZELLIJ CONFIG ---
ZELLIJ_CONF_DIR="$HOME/.config/zellij"
REPO_ZELLIJ="$REPO_ROOT/sh/configs/zellij"

if [ -d "$REPO_ZELLIJ" ]; then
    mkdir -p "$ZELLIJ_CONF_DIR/layouts"
    # Генеруємо конфіг з copy_on_select = true
    cat << KDL > "$REPO_ZELLIJ/config.kdl"
theme "gruvbox-dark"
default_layout "s0"
mouse_mode true
copy_on_select true 
copy_command "pbcopy"
KDL
    ln -sf "$REPO_ZELLIJ/config.kdl" "$ZELLIJ_CONF_DIR/config.kdl"
    ln -sf "$REPO_ZELLIJ/s0.kdl" "$ZELLIJ_CONF_DIR/layouts/s0.kdl"
fi

echo "🚀 System Operational."