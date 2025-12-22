#!/bin/bash
# s0fractal Connection Healer v1.0
# Switches transport from SSH (Identity Hell) to HTTPS (GH CLI Token)

echo "🚑 Healing Network Connections..."

# 1. Authorize GH CLI (якщо ще ні)
if ! gh auth status >/dev/null 2>&1; then
    echo "🔑 Authenticating via GitHub CLI..."
    gh auth login -p https -w
fi

# 2. Configure Git to use GH as credential helper
echo "🔧 Configuring Git Credential Helper..."
gh auth setup-git

# 3. Fix Remotes (Recursively)
# Функція для зміни URL
fix_remote() {
    local DIR=$1
    if [ -d "$DIR/.git" ] || [ -f "$DIR/.git" ]; then
        echo "   Target: $DIR"
        cd "$DIR"
        
        # Отримуємо поточний URL
        REMOTE=$(git remote get-url origin 2>/dev/null)
        
        # Якщо це SSH, міняємо на HTTPS
        if [[ "$REMOTE" == git@github.com:* ]]; then
            # Вирізаємо 'git@github.com:' і замінюємо на 'https://github.com/'
            NEW_URL=$(echo "$REMOTE" | sed 's|git@github.com:|https://github.com/|')
            git remote set-url origin "$NEW_URL"
            echo "     ↻ Switched to HTTPS: $NEW_URL"
        elif [[ -z "$REMOTE" ]]; then
             echo "     ! No remote found"
        else
             echo "     ✓ Already HTTPS or other"
        fi
        
        # Повертаємось назад (враховуючи, що ми могли зайти в глибину)
        cd - > /dev/null
    fi
}

# Лікуємо Void (Корінь)
echo "🌌 Fixing Void..."
fix_remote "$PWD"

# Лікуємо Сабмодулі (sh, glyphs, nodes...)
echo "📦 Fixing Submodules..."
git submodule foreach --recursive '
    URL=$(git remote get-url origin)
    if [[ "$URL" == git@github.com:* ]]; then
        NEW_URL=$(echo "$URL" | sed "s|git@github.com:|https://github.com/|")
        git remote set-url origin "$NEW_URL"
        echo "     ↻ Fixed: $name -> HTTPS"
    fi
'

echo "✅ Connection Protocol Switched to HTTPS."
echo "👉 Try 'git push' or 'λ Δ' now."