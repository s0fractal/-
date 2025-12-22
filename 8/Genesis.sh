#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM Genesis.sigma
# 🌊 FREQUENCY: sh | ENERGY: 8
# s0fractal Genesis v3.1 (Self-Hosted)
# Collapses .sigma Wave Functions into Material Reality.

# Load Context
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$REPO_ROOT/sh/tensor.sh"

SOURCE="$1"
if [ -z "$SOURCE" ]; then echo "Usage: genesis <file.sigma>"; exit 1; fi

# --- 1. Audit DNA (Frontmatter) ---
FM=$(sed -n '/^---$/,/^---$/p' "$SOURCE" | sed '/^---$/d')
ENERGY=$(echo "$FM" | grep "^ENERGY:" | cut -d':' -f2 | xargs)
GLYPH=$(echo "$FM" | grep "^GLYPH:" | cut -d':' -f2 | xargs)

if [ -z "$ENERGY" ] || [ -z "$GLYPH" ]; then
    echo "⚠️  Quantum Decoherence: Missing ENERGY or GLYPH in $SOURCE"
    exit 1
fi

echo "👁️  Observing: $GLYPH (E$ENERGY)"

# --- 2. Wave Collapse (Body) ---
IN_FREQ=0
CAPTURING=0
TARGET=""
PREFIX=""

while IFS= read -r line; do
    # Start of freq block: @[id]
    if [[ "$line" =~ ^@\[([a-z]+)\] ]]; then
        ID="${BASH_REMATCH[1]}"
        VECTOR=$(get_vector "$ID")
        
        # If no vector found, we are not in a valid dimension block
        if [ -z "$VECTOR" ]; then
            IN_FREQ=0
            continue
        fi

        IFS='|' read -r VID VTYPE VPATH VCOL VSYN VMUTE VLIFT <<< "$VECTOR"
        
        # Target Path Construction
        TARGET="$REPO_ROOT/$VPATH$ENERGY/$GLYPH.$VID"
        PREFIX="$VMUTE"
        [ -z "$PREFIX" ] && PREFIX="// "
        
        echo "   ⚡ Collapse @[$ID] -> $VPATH$ENERGY/$GLYPH.$VID"
        mkdir -p "$(dirname "$TARGET")"
        
        # Initialize with Syntax DNA
        if [ -n "$VLIFT" ]; then
            echo "$VLIFT" > "$TARGET"
            echo "${PREFIX}🛑 QUANTUM STATE: COLLAPSED FROM $(basename "$SOURCE")" >> "$TARGET"
        else
            echo "${PREFIX}🛑 QUANTUM STATE: COLLAPSED FROM $(basename "$SOURCE")" > "$TARGET"
        fi
        echo "${PREFIX}🌊 FREQUENCY: $ID | ENERGY: $ENERGY" >> "$TARGET"
        
        # Grant execution for shell frequency
        [[ "$ID" == "sh" ]] && chmod +x "$TARGET"
        
        IN_FREQ=1
        continue
    fi

    # Markdown Fences (Toggle Capture)
    if [[ "$line" =~ ^\`\`\` ]]; then
        if [ $IN_FREQ -eq 1 ]; then
            if [ $CAPTURING -eq 1 ]; then
                CAPTURING=0
                IN_FREQ=0
                TARGET=""
            else
                CAPTURING=1
            fi
        fi
        continue
    fi

    # Project content to Material File
    if [ $CAPTURING -eq 1 ] && [ -n "$TARGET" ]; then
        echo "$line" >> "$TARGET"
    fi
done < "$SOURCE"

echo "✅ Observation Complete."
