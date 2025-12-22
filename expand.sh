#!/bin/bash
# Usage: λ ⊕ <name>
# Version: Demiurge v4 (GH CLI Integration)

TARGET=$1
if [ -z "$TARGET" ]; then echo "Usage: $0 <name> (or .sigma file)"; exit 1; fi

# --- Logic: GENESIS (Materialization) ---
if [ -f "$TARGET" ]; then
    ./sh/genesis.sh "$TARGET"
    exit $?
fi

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
# --- Logic: TENSOR (Matrix Dimensions) ---
else
    # Load Tensor Engine
    source "$(dirname "$0")/tensor.sh"
    
    VECTOR=$(get_vector "$TARGET")
    
    if [ -n "$VECTOR" ]; then
        IFS='|' read -r ID STORAGE PATH_VAL SYNTAX COLOR <<< "$VECTOR"
        echo "🌌 Expanding Tensor Dimension: '$ID' ($STORAGE)..."
        
        # 1. Submodule Logic (Git Branch)
        if [[ "$STORAGE" == "submodule" ]]; then
             ROOT_DIR=$(git rev-parse --show-toplevel)
             CURRENT_BRANCH=$(git branch --show-current)
             cd "$ROOT_DIR"
             
             if [ -d "$PATH_VAL" ]; then
                 echo "⚠️  Dimension '$ID' path '$PATH_VAL' already exists."
             else
                 # Check if branch exists
                 if git show-ref --verify --quiet "refs/heads/$ID"; then
                     echo "⚠️  Branch '$ID' already exists. Linking..."
                 else
                     echo "🌱 Genesis: Creating orphan branch '$ID'..."
                     git checkout --orphan "$ID"
                     git rm -rf .
                     echo "# Dimension: $ID" > README.md
                     git add README.md
                     git commit -m "⊕ Genesis: $ID dimension"
                     git push -u origin "$ID"
                     git checkout "$CURRENT_BRANCH"
                 fi
                 
                 # Add Submodule
                 echo "🔗 Linking submodule '$PATH_VAL'..."
                 git submodule add -b "$ID" ./ "$PATH_VAL"
                 git commit -m "Link dimension: $ID"
                 git push origin "$CURRENT_BRANCH"
             fi
             
        # 2. Folder Logic (Simple Directory)
        elif [[ "$STORAGE" == "folder" ]] || [[ "$STORAGE" == "virtual" ]]; then
             if [ -d "$PATH_VAL" ]; then
                 echo "✅ Folder '$PATH_VAL' already exists."
             else
                 echo "📂 Creating folder '$PATH_VAL'..."
                 mkdir -p "$PATH_VAL"
                 touch "$PATH_VAL/.keep"
             fi
        fi
        echo "✅ Dimension '$ID' expanded."
        
    else
        echo "❌ Unknown Target: '$TARGET'. Not a file, node, or matrix dimension."
        exit 1
    fi
fi
