#!/bin/bash
# s0fractal Topology Doctor v1.0
# Checks if Reality matches Intent.

echo "⚕️  Scanning Vital Signs..."

ERRORS=0
WARNINGS=0

report_error() { echo "❌ $1"; ((ERRORS++)); }
report_warn()  { echo "⚠️  $1"; ((WARNINGS++)); }
report_ok()    { echo "✅ $1"; }

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
else
    report_ok "State: On branch '$BRANCH'"
fi

if [ -z "$(git status --porcelain)" ]; then
    report_ok "Cleanliness: Working tree is clean"
else
    report_warn "Cleanliness: Uncommitted changes detected"
fi

# 4. TOPOLOGY MAP (Submodules)
echo "🕸  Checking Submodule Topology..."
git submodule status --recursive | while read -r line; do
    STATUS=${line:0:1}
    PATH_NAME=$(echo "$line" | awk '{print $2}')
    
    if [[ "$STATUS" == "-" ]]; then
        report_error "Node $PATH_NAME is NOT initialized"
    elif [[ "$STATUS" == "+" ]]; then
        report_warn "Node $PATH_NAME has shifted (version mismatch)"
    else
        echo "   ✓ $PATH_NAME is aligned"
    fi
done

# SUMMARY
echo "--------------------------------"
if [ $ERRORS -eq 0 ]; then
    echo "🟢 SYSTEM HEALTHY. Reality matches Intent."
else
    echo "🔴 CRITICAL FAILURES: $ERRORS found."
    exit 1
fi
