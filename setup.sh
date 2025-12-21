#!/bin/bash

echo "🔮 Tuning s0fractal Environment..."

# --- Git Aliases ---
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.sync "!git pull && git submodule update --init --recursive"

# --- Zsh/Bash Alias for λ ---
# Визначаємо шлях до кореня репо
REPO_ROOT=$(pwd)

# Додаємо аліас у файл конфігурації шелла (обережно, щоб не дублювати)
SHELL_RC="$HOME/.zshrc"
if [ -n "$BASH_VERSION" ]; then SHELL_RC="$HOME/.bashrc"; fi

if ! grep -q "alias λ=" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# s0fractal Lambda Protocol" >> "$SHELL_RC"
    # Аліас 'λ' викликає скрипт lambda.sh з поточного репо
    # УВАГА: Це працюватиме тільки коли ти всередині репо.
    # Щоб зробити глобально, треба абсолютний шлях, але поки зробимо локально:
    echo "alias λ='$REPO_ROOT/sh/lambda.sh'" >> "$SHELL_RC"
    echo "✅ Alias 'λ' added to $SHELL_RC"
    echo "👉 Please run: source $SHELL_RC"
else
    echo "ℹ️  Alias 'λ' already exists."
fi

echo "🚀 Ready. Try: λ ?"
