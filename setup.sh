#!/bin/bash

echo "🔮 Tuning s0fractal Environment..."
REPO_ROOT=$(pwd)

# 1. Git Aliases
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.sync "!git pull && git submodule update --init --recursive"
git config --global alias.nuke "!git clean -fd && git reset --hard"

# 2. Shell Alias (λ)
TARGET_RC=""
ALIAS_CMD=""
if [ -f "$HOME/.zshrc" ]; then
    TARGET_RC="$HOME/.zshrc"
    ALIAS_CMD="alias λ='noglob $REPO_ROOT/sh/lambda.sh'" 
elif [ -f "$HOME/.bashrc" ]; then
    TARGET_RC="$HOME/.bashrc"
    ALIAS_CMD="alias λ='$REPO_ROOT/sh/lambda.sh'"
fi

if [ -n "$TARGET_RC" ]; then
    if ! grep -q "alias λ=" "$TARGET_RC"; then
        echo "" >> "$TARGET_RC"
        echo "# s0fractal Lambda Protocol" >> "$TARGET_RC"
        echo "$ALIAS_CMD" >> "$TARGET_RC"
        echo "✅ Alias 'λ' injected."
    fi
fi

# 3. Hooks
HOOK_DIR="../.git/hooks"
if [ -d "$HOOK_DIR" ]; then
    echo "#!/bin/sh" > "$HOOK_DIR/post-checkout"
    echo "exec < /dev/tty" >> "$HOOK_DIR/post-checkout"
    echo "git submodule update --init --recursive" >> "$HOOK_DIR/post-checkout"
    chmod +x "$HOOK_DIR/post-checkout"
    echo "✅ Hook installed: post-checkout"
fi

# 4. Zellij Sync (New!)
ZELLIJ_CONF_DIR="$HOME/.config/zellij"
REPO_ZELLIJ="$REPO_ROOT/sh/configs/zellij"
if [ -d "$REPO_ZELLIJ" ]; then
    mkdir -p "$ZELLIJ_CONF_DIR/layouts"
    ln -sf "$REPO_ZELLIJ/config.kdl" "$ZELLIJ_CONF_DIR/config.kdl"
    ln -sf "$REPO_ZELLIJ/s0.kdl" "$ZELLIJ_CONF_DIR/layouts/s0.kdl"
    echo "✅ Zellij configs linked."
fi

echo "🚀 s0fractal environment ready."
