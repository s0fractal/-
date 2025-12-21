#!/bin/bash
# Usage: ./expand.sh <dimension_name>
DIM=$1
if [ -z "$DIM" ]; then echo "Usage: $0 <name>"; exit 1; fi

echo "🌌 Expanding universe into '$DIM'..."

# Зберігаємо поточну гілку
CURRENT=$(git branch --show-current)

# Створюємо нову сирітську гілку
git checkout --orphan $DIM
git rm -rf .
echo "# Dimension: $DIM" > README.md
git add .
git commit -m "Genesis: $DIM dimension initialized"

# Повертаємось і лінкуємо
git checkout $CURRENT
# (Тут хитрість: додаємо локально, при пуші треба буде налаштувати origin)
git submodule add -b $DIM ./ $DIM
git commit -m "Link dimension: $DIM"

echo "✅ Dimension '$DIM' created and linked."
