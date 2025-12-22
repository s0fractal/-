#!/bin/bash
# s0fractal Absorb v1.0
# The Mouth of the Void. Ingests raw signals into Chaos.

SIGNAL="$1"
if [ -z "$SIGNAL" ]; then echo "Usage: λ absorb 'some idea' (or file)"; exit 1; fi

# 1. Визначаємо тіло сигналу
BODY=""
if [ -f "$SIGNAL" ]; then
    BODY=$(cat "$SIGNAL")
    ORIGIN="file:$(basename "$SIGNAL")"
else
    BODY="$SIGNAL"
    ORIGIN="cli:input"
fi

# 2. Створюємо унікальний ID (Hash of Content + Time)
TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
# Use shasum if available, else md5 or cksum
if command -v shasum >/dev/null; then
    HASH=$(echo "$BODY" | shasum -a 256 | head -c 8)
else
    HASH=$(echo "$BODY" | md5 | head -c 8)
fi
ID="${TIMESTAMP}-${HASH}"

# 3. Шлях до Хаосу (Repo Root resolving)
# Assuming we are running from root or finding it
if [ -d ".git" ]; then
    REPO_ROOT="$PWD"
else
    REPO_ROOT=$(git rev-parse --show-toplevel)
fi

CHAOS_DIR="$REPO_ROOT/sigma/chaos"
TARGET="$CHAOS_DIR/$ID.sigma"

# Ensure chaos exists
mkdir -p "$CHAOS_DIR"

# 4. Замикання (Wrapping in Envelope)
cat << EOF > "$TARGET"
TYPE: RAW_SIGNAL
ID: $ID
ORIGIN: $ORIGIN
STATUS: UNRESOLVED
---
$BODY
EOF

# 5. Фіксація (Поглинання)
echo "🌪  Absorbing $ID into Chaos..."
(
    cd "$CHAOS_DIR" || exit
    # Ensure we are in the submodule root for git operations
    # chaos is inside sigma/
    cd .. 
    
    git add "chaos/$ID.sigma"
    git commit -m "🌪 Absorb: Signal $ID entered the Horizon"
    
    # Smart Push
    # Try to push to the tracked branch, or fallback to glyphs if detached
    BRANCH=$(git branch --show-current)
    if [ -z "$BRANCH" ]; then
        # Detached
        echo "   (Detached Head - Pushing to origin/glyphs)"
        git push origin HEAD:glyphs
    else
        git push origin "$BRANCH"
    fi
)

echo "✅ Absorbed into Chaos: $ID"
echo "📍 Location: sigma/chaos/$ID.sigma"
