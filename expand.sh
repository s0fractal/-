#!/bin/bash
# Usage: λ ⊕ <name>
# Example: λ ⊕ topology (Internal Dimension)
# Example: λ ⊕ 0-ts     (External Node)

TARGET=$1
if [ -z "$TARGET" ]; then echo "Usage: $0 <name>"; exit 1; fi

# --- Logic: NODE (External Repo) ---
if [[ "$TARGET" =~ ^[0-9]+-[a-z]+$ ]]; then
    echo "🌟 Spawning External Node: '$TARGET'..."
    
    # 1. Виходимо з Void, щоб створити чисту папку поруч (або в tmp)
    # Щоб не бруднити поточний репо, робимо структуру в ../$TARGET, потім підключаємо
    NODE_DIR="../$TARGET"
    
    if [ -d "$NODE_DIR" ]; then echo "⚠️  Directory $NODE_DIR already exists!"; exit 1; fi
    
    mkdir -p "$NODE_DIR"
    echo "# Node: $TARGET" > "$NODE_DIR/README.md"
    
    # 2. Ініціалізація Гіта
    cd "$NODE_DIR"
    git init -b main
    
    # 3. Вживлення Ядра (Void як сабмодуль)
    # Ми використовуємо абсолютний шлях, щоб це працювало скрізь
    mkdir -p meta
    git submodule add git@github.com:s0fractal/-.git meta/root
    
    # 4. Генетика (deno.json для TS)
    if [[ "$TARGET" == *"-ts" ]]; then
        echo '{ "compilerOptions": { "strict": true }, "imports": { "~": "./meta/root/" } }' > deno.json
        mkdir ts
        echo "export const I = <T>(x: T) => x;" > ts/I.ts
    fi
    
    # 5. Перший подих
    git add .
    git commit -m "⊕ Genesis: Node initialized with Void link"
    
    # 6. Інструкція для Деміурга
    echo "---------------------------------------------------"
    echo "✅ Node '$TARGET' created locally at $NODE_DIR"
    echo "⚠️  ACTION REQUIRED:"
    echo "1. Go to GitHub -> New Repository -> Name: '$TARGET'"
    echo "2. Run these commands inside $NODE_DIR:"
    echo "   git remote add origin git@github.com:s0fractal/$TARGET.git"
    echo "   git push -u origin main"
    echo "3. Then come back to Void and run:"
    echo "   git submodule add git@github.com:s0fractal/$TARGET.git nodes/$TARGET"
    echo "---------------------------------------------------"
    
# --- Logic: DIMENSION (Internal Branch) ---
else
    echo "🌌 Expanding Internal Dimension: '$TARGET'..."
    
    # Зберігаємо де ми були
    ROOT_DIR=$(git rev-parse --show-toplevel)
    CURRENT_BRANCH=$(git branch --show-current)
    
    cd "$ROOT_DIR"
    
    # Створюємо гілку
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
    
    # Лінкуємо в main
    git checkout "$CURRENT_BRANCH"
    
    if [ -d "$TARGET" ]; then
        echo "ℹ️  Path '$TARGET' already linked."
    else
        git submodule add -b "$TARGET" ./ "$TARGET"
        git commit -m "Link dimension: $TARGET"
        git push origin "$CURRENT_BRANCH"
    fi
    
    echo "✅ Internal Dimension '$TARGET' expanded."
fi
