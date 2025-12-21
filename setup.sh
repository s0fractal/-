#!/bin/bash

echo "🔮 Tuning s0fractal Environment..."

# --- 1. Git Aliases (Global) ---
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.sync "!git pull && git submodule update --init --recursive"
git config --global alias.nuke "!git clean -fd && git reset --hard"

# --- 2. Shell Alias Injection (Smart Detect) ---
REPO_ROOT=$(pwd)
TARGET_RC=""
ALIAS_CMD=""

# Пріоритет 1: Zsh (Стандарт для Mac і хакерів)
if [ -f "$HOME/.zshrc" ]; then
    TARGET_RC="$HOME/.zshrc"
    # Для Zsh додаємо noglob, щоб працював знак питання (λ ?)
    ALIAS_CMD="alias λ='noglob $REPO_ROOT/sh/lambda.sh'" 
    echo "Detected Zsh environment."

# Пріоритет 2: Bash (Linux сервери, старі системи)
elif [ -f "$HOME/.bashrc" ]; then
    TARGET_RC="$HOME/.bashrc"
    # Bash не вміє noglob в аліасах так просто, тому без нього
    ALIAS_CMD="alias λ='$REPO_ROOT/sh/lambda.sh'"
    echo "Detected Bash environment."
fi

# Ін'єкція
if [ -n "$TARGET_RC" ]; then
    if ! grep -q "alias λ=" "$TARGET_RC"; then
        echo "" >> "$TARGET_RC"
        echo "# s0fractal Lambda Protocol" >> "$TARGET_RC"
        echo "$ALIAS_CMD" >> "$TARGET_RC"
        echo "✅ Alias 'λ' injected into $TARGET_RC"
        echo "👉 Please run: source $TARGET_RC"
    else
        echo "ℹ️  Alias 'λ' already exists in $TARGET_RC"
        # Перестраховка: якщо шлях змінився, оновлюємо його (через sed)
        # Але це для просунутих. Поки залишимо як є.
    fi
else
    echo "⚠️  Could not find .zshrc or .bashrc. Please add alias manually."
fi

# --- 3. Hooks ---
HOOK_DIR="../.git/hooks"
if [ -d "$HOOK_DIR" ]; then
    echo "#!/bin/sh" > "$HOOK_DIR/post-checkout"
    echo "exec < /dev/tty" >> "$HOOK_DIR/post-checkout" # Fix for interaction if needed
    echo "git submodule update --init --recursive" >> "$HOOK_DIR/post-checkout"
    chmod +x "$HOOK_DIR/post-checkout"
    echo "✅ Hook installed: post-checkout"
fi

echo "🚀 s0fractal environment ready."
