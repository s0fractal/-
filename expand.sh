#!/bin/bash
# Usage: λ ⊕ <name>
# Version: Demiurge v4 (GH CLI Integration)

TARGET=$1
if [ -z "$TARGET" ]; then echo "Usage: $0 <name>"; exit 1; fi

# --- Logic: NODE (External Repo) ---
if [[ "$TARGET" =~ ^[0-9]+-[a-z]+$ ]]; then
    echo "🌟 Spawning External Node: '$TARGET'..."
    
    # 1. Створюємо папку поруч (симуляція Network)
    NODE_DIR="../$TARGET"
    if [ -d "$NODE_DIR" ]; then echo "⚠️  Directory $NODE_DIR already exists!"; exit 1; fi
    
    mkdir -p "$NODE_DIR"
    echo "# Node: $TARGET" > "$NODE_DIR/README.md"
    
    # 2. Локальна ініціалізація
    cd "$NODE_DIR"
    git init -b main
    
    # 3. Вживлення Ядра (Void)
    mkdir -p meta
    git submodule add git@github.com:s0fractal/-.git meta/root
    
    # 4. Генетика (TS/RS)
    if [[ "$TARGET" == *"-ts" ]]; then
        echo '{ "compilerOptions": { "strict": true }, "imports": { "~": "./meta/root/" } }' > deno.json
        mkdir ts
        echo "export const I = <T>(x: T) => x;" > ts/I.ts
    fi
    
    git add .
    git commit -m "⊕ Genesis: Node initialized"
    
    # 5. МАГІЯ GH: Створення на сервері та пуш
    echo "☁️  Materializing on GitHub..."
    # Створюємо публічний репо в організації/юзера s0fractal
    # --source=. означає "візьми поточну папку і запуш її туди"
    gh repo create "s0fractal/$TARGET" --public --source=. --remote=origin --push
    
    # 6. Інтеграція назад у Void
    echo "🔗 Linking to Grid..."
    cd ../void # Повертаємось у базу
    git submodule add "git@github.com:s0fractal/$TARGET.git" "nodes/$TARGET"
    git commit -m "⊕ Nodes: Connected $TARGET to the Grid"
    git push
    
    echo "✅ Node '$TARGET' is alive and connected."

# --- Logic: DIMENSION (Internal Branch) ---
else
    # (Ця частина без змін, але для повноти файлу...)
    echo "🌌 Expanding Internal Dimension: '$TARGET'..."
    ROOT_DIR=$(git rev-parse --show-toplevel)
    CURRENT_BRANCH=$(git branch --show-current)
    cd "$ROOT_DIR"
    
    if git show-ref --verify --quiet "refs/heads/$TARGET"; then
        echo "⚠️  Dimension '$TARGET' already exists."
    else
        git checkout --orphan "$TARGET"
        git rm -rf .
        echo "# Dimension: $TARGET" > README.md
        git add README.md
        git commit -m "⊕ Genesis: $TARGET dimension"
        git push -u origin "$TARGET"
    fi
    
    git checkout "$CURRENT_BRANCH"
    if [ ! -d "$TARGET" ]; then
        git submodule add -b "$TARGET" ./ "$TARGET"
        git commit -m "Link dimension: $TARGET"
        git push origin "$CURRENT_BRANCH"
    fi
    echo "✅ Internal Dimension '$TARGET' expanded."
fi
