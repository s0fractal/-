#!/bin/bash
# s0fractal Genesis v2.0
# Transmutes Intent (.sigma) into Matter (.ts/.rs) by extracting code blocks.

# Usage: λ genesis <path/to/file.sigma>

SOURCE="$1"
if [ -z "$SOURCE" ]; then echo "Usage: ./genesis.sh <recipe.sigma>"; exit 1; fi

# Load Context
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/env.sh"

echo "🔥 Materializing spirit from $SOURCE..."

# 0. Context Recognition (Layer Detection)
# Try to extract layer from path: .../sigma/1/File.sigma -> LAYER=1
if [[ "$SOURCE" =~ sigma/([0-9]+)/ ]]; then
    LAYER="${BASH_REMATCH[1]}"
    echo "   📍 Context: Layer $LAYER"
else
    # Fallback/Chaos
    LAYER=""
    echo "   📍 Context: Unknown/Global (No layer detected in path)"
fi

# 1. Parsing & Materialization
IN_BLOCK=0
TARGET_FILE=""

while IFS= read -r line; do
    # Початок блоку: ` ```lang:path/to/file `
    # Regex captures everything after the colo as the relative path
    if [[ "$line" =~ ^\`\`\`[a-zA-Z0-9_-]+:(.+) ]]; then
        REL_PATH="${BASH_REMATCH[1]}"
        
        # Determine Dimension based on extension
        EXTENSION="${REL_PATH##*.}"
        DIMENSION=""
        
        case "$EXTENSION" in
            ts) DIMENSION="ts" ;;
            rs) DIMENSION="rs" ;;
            lean) DIMENSION="lean" ;;
            sh) DIMENSION="sh" ;;
            rb) DIMENSION="rb" ;;
            md) DIMENSION="md" ;;
            *)  DIMENSION="unknown" ;;
        esac
        
        # Route to Target
        if [ -n "$LAYER" ] && [ "$DIMENSION" != "unknown" ]; then
            # Magic: Inject into the Dimension's Layer Node
            # e.g. void/ts/0/I.ts
            TARGET_FILE="$REPO_ROOT/$DIMENSION/$LAYER/$REL_PATH"
        else
            # Explicit path or global dimension
            TARGET_FILE="$REPO_ROOT/$REL_PATH"
        fi

        echo "   ⚡ Materializing -> $DIMENSION/$LAYER/$(basename "$REL_PATH")"
        
        # Ensure directory exists
        mkdir -p "$(dirname "$TARGET_FILE")"
        
        # Clear/Create file with auto-generated header
        echo "// 🛑 DO NOT EDIT. GENERATED FROM $(basename "$SOURCE")" > "$TARGET_FILE"
        
        IN_BLOCK=1
        continue
    fi

    # Кінець блоку
    if [[ "$line" == "\`\`\`" ]] && [ $IN_BLOCK -eq 1 ]; then
        IN_BLOCK=0
        TARGET_FILE=""
        continue
    fi

    # Запис вмісту
    if [ $IN_BLOCK -eq 1 ]; then
        echo "$line" >> "$TARGET_FILE"
    fi

done < "$SOURCE"

echo "✅ Genesis Complete."
