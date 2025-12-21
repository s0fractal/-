#!/bin/bash

echo "🔮 Initializing s0fractal Environment..."

# --- 1. АЛІАСИ (Заклинання) ---

# 'git universe' - Візуалізація топології
# Показує дерево комітів як схему метро з хешами та авторами
git config --global alias.universe "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"

# 'git sync' - Сінхронізація Реальності
# Тягне зміни і одразу оновлює сабмодулі (щоб не робити це в два кроки)
git config --global alias.sync "!git pull && git submodule update --init --recursive"

# 'git nuke' - Екстрена чистка (обережно!)
# Видаляє всі невідстежувані файли і скидає зміни (корисно для тестів)
git config --global alias.nuke "!git clean -fd && git reset --hard"

echo "✅ Aliases installed: git universe, git sync, git nuke"

# --- 2. ХУКИ (Нервова Система) ---

# post-checkout: Автоматично оновлює сабмодулі при перемиканні гілок
HOOK_DIR="../.git/hooks"
if [ -d "$HOOK_DIR" ]; then
    echo "#!/bin/sh" > "$HOOK_DIR/post-checkout"
    echo "echo '🔄 Auto-aligning submodules...'" >> "$HOOK_DIR/post-checkout"
    echo "git submodule update --init --recursive" >> "$HOOK_DIR/post-checkout"
    chmod +x "$HOOK_DIR/post-checkout"
    echo "✅ Hook installed: post-checkout (Auto-submodule update)"
else
    echo "⚠️  Warning: Hooks directory not found (Are you in the root of a repo?)"
fi

echo "🚀 s0fractal environment ready. Welcome to the Void."
