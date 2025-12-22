#!/bin/bash
# s0fractal Topology Doctor v1.1
# Now with prescriptive analytics.

echo "⚕️  Scanning Vital Signs..."

ERRORS=0
WARNINGS=0

report_error() { echo "❌ $1"; ((ERRORS++)); }
report_warn()  { echo "⚠️  $1"; ((WARNINGS++)); }
report_ok()    { echo "✅ $1"; }
suggest_fix()  { echo "   👉 Fix: $1"; }

# 1. CONTEXT
REPO_ROOT=$(git rev-parse --show-toplevel)
DIR_NAME=$(basename "$REPO_ROOT")
echo "📍 Context: $DIR_NAME"

# 2. STATE
if [ -z "$(git status --porcelain)" ]; then
    report_ok "State: Clean"
else
    report_warn "State: Dirty (Uncommitted changes)"
    suggest_fix "λ Δ 'wip'"
fi

# 3. TOPOLOGY SCAN
echo "🕸  Checking Submodule Grid..."

# Отримуємо статус і помилки окремо
MODULES_STATUS=$(git submodule status --recursive 2>&1)

# Перевірка на фатальні помилки конфігурації
if echo "$MODULES_STATUS" | grep -q "fatal: no submodule mapping"; then
    BROKEN_PATH=$(echo "$MODULES_STATUS" | grep "fatal" | awk -F"'" '{print $2}')
    report_error "Configuration Gap: Path '$BROKEN_PATH' exists but is not in .gitmodules"
    suggest_fix "git submodule add -b <branch> ./ $BROKEN_PATH"
fi

# Порядковий аналіз
echo "$MODULES_STATUS" | while read -r line; do
    # Ігноруємо рядки помилок, бо ми їх вже зловили вище
    if [[ "$line" == fatal* ]]; then continue; fi
    
    STATUS_CHAR=${line:0:1}
    PATH_NAME=$(echo "$line" | awk '{print $2}')
    
    case "$STATUS_CHAR" in
        "-")
            report_error "Node '$PATH_NAME' is uninitialized (Ghost)"
            suggest_fix "λ ⋈ (or git submodule update --init --recursive)"
            ;;
        "+")
            report_warn "Node '$PATH_NAME' has drifted (Version mismatch)"
            suggest_fix "git add $PATH_NAME && git commit -m '⋈ Sync $PATH_NAME'"
            ;;
        "U")
            report_error "Node '$PATH_NAME' has merge conflicts"
            ;;
        " ")
            echo "   ✓ $PATH_NAME is aligned"
            ;;
    esac
done

# SUMMARY
echo "--------------------------------"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "🟢 SYSTEM PERFECT. Resonance 100%."
elif [ $ERRORS -eq 0 ]; then
    echo "🟡 SYSTEM STABLE with warnings."
else
    echo "🔴 CRITICAL FRACTURES DETECTED."
    exit 1
fi
