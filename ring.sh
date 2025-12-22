#!/bin/bash
# s0fractal Ring Builder v2.0 (Mirror Topology)
# Usage: λ ring <layer_id> (e.g., 0, 1, 2)

LAYER=$1
if [ -z "$LAYER" ]; then echo "Usage: $0 <layer_number>"; exit 1; fi

# Налаштування
ORG="s0fractal"
RING_NAME="$LAYER"
# DIMS: The dimensions we support - 🧬 (Pure Source), MD (Chronicles), TS (Logic), RS (Force), LEAN (Proof)
DIMS=("ts" "rs" "lean" "md" "🧬") 

echo "🪐 Forging Ring Layer: $LAYER..."

# 1. Check/Create Dimension Nodes
FOUND_DIMENSIONS=0

for DIM in "${DIMS[@]}"; do
    # Target Repo Name: e.g. "1-ts", "1-rs"
    NODE_NAME="$LAYER-$DIM"
    TARGET_PATH="$DIM/$LAYER"
    # Use HTTPS for better compatibility if SSH keys are missing/restricted
    REPO_URL="https://github.com/$ORG/$NODE_NAME.git"
    
    echo "   🔍 Checking Dimension: $DIM ($NODE_NAME)..."

    # Check if repo exists
    if gh repo view "$ORG/$NODE_NAME" >/dev/null 2>&1; then
        echo "      ✅ Node exists in Void."
        
        # Check if submodule exists in local Void
        if [ -d "$TARGET_PATH" ]; then
             echo "      🔗 Already linked at ./$TARGET_PATH"
        else
             echo "      🧲 Linking to ./$TARGET_PATH..."
             mkdir -p "$DIM"
             git submodule add --force "$REPO_URL" "$TARGET_PATH"
        fi
        ((FOUND_DIMENSIONS++))
    else
        echo "      ✨ Creating new Node: $NODE_NAME..."
        # Create remote repo
        gh repo create "$ORG/$NODE_NAME" --public --description "Dimension $DIM of Ring $LAYER"
        
        # Init local scaffolding (Hyper-Compression)
        mkdir -p "$TARGET_PATH"
        
        # Initialize as disjoint git repo
        (
            cd "$TARGET_PATH"
            git init -b main
            echo "// Genesis of $LAYER-$DIM" > "GENESIS.$DIM"
            git add .
            git commit -m "⊕ Genesis"
            git remote add origin "$REPO_URL"
            git push -u origin main
        )
        
        # 3. We git submodule add it back from remote.
        rm -rf "$TARGET_PATH"
        git submodule add --force "$REPO_URL" "$TARGET_PATH"
        
        ((FOUND_DIMENSIONS++))
    fi
done

echo "✅ Ring $LAYER processed. Active Dimensions: $FOUND_DIMENSIONS"
