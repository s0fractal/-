#!/bin/bash
# s0fractal Genesis v1.0
# Transmutes Intent (.sigma) into Matter (.ts/.rs)

RECIPE=$1
if [ -z "$RECIPE" ]; then echo "Usage: ./genesis.sh <recipe.sigma>"; exit 1; fi

echo "🔥 Materializing spirit from $RECIPE..."

# 1. Читаємо Душу (парсинг)
# (В майбутньому тут буде AI, зараз - простий grep)
GLYPH=$(grep "GLYPH:" "$RECIPE" | cut -d' ' -f2)
NAME=$(grep "NAME:" "$RECIPE" | cut -d' ' -f2)
TARGET=$(grep "TARGET:" "$RECIPE" | cut -d' ' -f2)

# Визначаємо абсолютний шлях до цілі
REPO_ROOT=$(git rev-parse --show-toplevel)
DEST="$REPO_ROOT/$TARGET"
DIR=$(dirname "$DEST")

mkdir -p "$DIR"

# 2. Створюємо Тіло (Генерація)
# Це і є "лінза", про яку ти казав.

cat << TS_EOF > "$DEST"
/**
 * 🛑 DO NOT EDIT. GENERATED CACHE.
 * Source: $RECIPE
 *
 * $NAME ($GLYPH)
 * The fundamental particle of existence.
 */

export const $GLYPH = <T>(x: T): T => x;
TS_EOF

echo "✅ Crystallized into $TARGET"
