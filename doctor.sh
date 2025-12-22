#!/bin/bash
# s0fractal Topology Doctor v1.0
# Checks if Reality matches Intent.

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "⚕️  ${YELLOW}Scanning Vital Signs...${NC}"

ERRORS=0
WARNINGS=0

report_error() { echo -e "${RED}❌ $1${NC}"; ((ERRORS++)); }
report_warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; ((WARNINGS++)); }
report_ok()    { echo -e "${GREEN}✅ $1${NC}"; }
suggest_fix()  { echo -e "   👉 Fix: $1"; }

# 1. WHO AM I? (Identity Check)
REPO_ROOT=$(git rev-parse --show-toplevel)
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
DIR_NAME=$(basename "$REPO_ROOT")

echo "📍 Context: $DIR_NAME"

if [[ "$REMOTE_URL" == *"s0fractal"* ]]; then
    report_ok "Identity: Valid s0fractal citizen"
else
    report_warn "Identity: Unknown origin ($REMOTE_URL)"
fi

# 2. THE UMBILICAL CORD (Void Connection)
# Якщо це не сам Void, він мусить мати meta/root
if [[ "$DIR_NAME" != "void" && "$DIR_NAME" != "-" ]]; then
    if [ -f "$REPO_ROOT/meta/root/.git" ] || [ -d "$REPO_ROOT/meta/root/.git" ]; then
        report_ok "Link: Connected to Void (meta/root)"
    else
        report_error "Link: SEVERED! Missing meta/root submodule."
        echo "   👉 Fix: git submodule add git@github.com:s0fractal/-.git meta/root"
    fi
else
    report_ok "Link: I am the Void (Root Node)"
fi

# 3. GIT HEALTH (Detached Heads & Dirty State)
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    report_warn "State: DETACHED HEAD (You are in time-limbo)"
    suggest_fix "git checkout main (or proper branch)"
else
    report_ok "State: On branch '$BRANCH'"
fi

if [ -z "$(git status --porcelain)" ]; then
    report_ok "Cleanliness: Working tree is clean"
else
    report_warn "Cleanliness: Uncommitted changes detected"
    suggest_fix "λ Δ 'wip'"
fi

# 4. TOPOLOGY SCAN (Submodules)
echo "🕸  Checking Submodule Grid..."

# Отримуємо статус і помилки окремо
# git submodule status повертає:
# - (мінус) якщо не ініціалізовано
# + (плюс) якщо хеш відрізняється
# U (U) якщо конфлікт
MODULES_STATUS=$(git submodule status --recursive 2>&1)

if echo "$MODULES_STATUS" | grep -q "fatal: no submodule mapping"; then
    BROKEN_PATH=$(echo "$MODULES_STATUS" | grep "fatal" | awk -F"'" '{print $2}')
    report_error "Configuration Gap: Path '$BROKEN_PATH' exists but is not in .gitmodules"
    suggest_fix "git submodule add -b <branch> ./ $BROKEN_PATH"
fi

echo "$MODULES_STATUS" | while read -r line; do
    if [[ "$line" == fatal* ]]; then continue; fi
    
    STATUS_CHAR=${line:0:1}
    PATH_NAME=$(echo "$line" | awk '{print $2}')
    
    if [ -z "$PATH_NAME" ]; then continue; fi

    case "$STATUS_CHAR" in
        "-")
            report_error "Node '$PATH_NAME' is uninitialized (Ghost)"
            suggest_fix "λ ⋈ (or git submodule update --init --recursive)"
            ;;
        "+")
            report_warn "Node '$PATH_NAME' has shifted (Version mismatch)"
            # Це не завжди помилка, часто це просто робочий процес
            ;;
        "U")
            report_error "Node '$PATH_NAME' has merge conflicts"
            ;;
        *)
            # Пробіл на початку означає все ок
            # echo "   ✓ $PATH_NAME is aligned" 
            ;;
    esac
done

# SUMMARY
echo "--------------------------------"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🟢 SYSTEM PERFECT. Resonance 100%.${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}🟡 SYSTEM STABLE with warnings.${NC}"
else
    echo -e "${RED}🔴 CRITICAL FRACTURES DETECTED.${NC}"
    exit 1
fi