#!/bin/bash
# s0fractal Genesis v3.0 (Quantum Observer)
# Collapses .sigma Wave Functions into Material Reality based on Energy and Spectrum.

# Usage: λ genesis <path/to/file.sigma>

SOURCE="$1"
if [ -z "$SOURCE" ]; then echo "Usage: ./genesis.sh <particle.sigma>"; exit 1; fi

# Load Context and Tensor Engine
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/tensor.sh"

echo "👁️  Observing Quantum State: $SOURCE..."

# --- 1. Parse Quantum Numbers (Frontmatter) ---
# Read everything between first pair of "---"
# Extract GLYPH, ENERGY (and optional SPECTRUM for validation)

ENERGY=""
GLYPH=""

IN_FM=0
LINE_NUM=0
while IFS= read -r line; do
    ((LINE_NUM++))
    if [[ "$line" == "---" ]]; then
        if [ $IN_FM -eq 0 ]; then IN_FM=1; continue; fi
        if [ $IN_FM -eq 1 ]; then IN_FM=0; break; fi # End of Frontmatter
    fi
    
    if [ $IN_FM -eq 1 ]; then
        if [[ "$line" =~ ^ENERGY:[[:space:]]*(.*)$ ]]; then
            ENERGY="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^GLYPH:[[:space:]]*(.*)$ ]]; then
            GLYPH="${BASH_REMATCH[1]}"
        fi
    fi
done < "$SOURCE"

if [ -z "$ENERGY" ] || [ -z "$GLYPH" ]; then
    echo "⚠️  Quantum Decoherence: Missing ENERGY or GLYPH in Frontmatter."
    # Fallback / Legacy mode or Error? Let's error to enforce new physics.
    exit 1
fi

echo "   ⚛️  Particle Detected: '$GLYPH' (Energy Level: $ENERGY)"

# --- 2. Wave Collapse (Body Parsing) ---
# Scan for @[freq] blocks and materialize them.

IN_BLOCK=0
CAPTURING_CODE=0
CURRENT_FREQ=""
TARGET_FILE=""

while IFS= read -r line; do
    # Start of Frequency Block: @[ts] ...
    if [[ "$line" =~ ^@\[([a-z]+)\] ]]; then
        CURRENT_FREQ="${BASH_REMATCH[1]}"
        
        # Consult Matrix for this Frequency
        VECTOR=$(get_vector "$CURRENT_FREQ")
        if [ -z "$VECTOR" ]; then
            echo "   ⚠️  Unknown Frequency: $CURRENT_FREQ (No Tensor Vector found)"
            IN_BLOCK=0
            continue
        fi
        
        IFS='|' read -r ID STORAGE PATH_VAL SYNTAX COLOR VMUTE VLIFT <<< "$VECTOR"
        
        # Collapse Wave Function -> Material Path
        # Formula: $REPO_ROOT / $DIM_PATH / $ENERGY / $GLYPH . $EXTENSION
        # We assume EXTENSION matches ID for simple types, or hardcode mapping if needed.
        # For 'ts' -> .ts, 'rs' -> .rs. ID is reliable for extension in this system.
        
        EXT="$ID" 
        # Fix for Rust if ID is 'rs' but ext is 'rs' (same). 
        # If ID was 'rust', ext would be wrong. But Matrix has ID=rs.
        
        TARGET_FILE="$REPO_ROOT/$PATH_VAL/$ENERGY/$GLYPH.$EXT"
        
        echo "   ⚡ Collapsing Wave @[$ID] -> $PATH_VAL$ENERGY/$GLYPH.$EXT"
        
        # Ensure existence
        mkdir -p "$(dirname "$TARGET_FILE")"
        
        # Write Headers (Syntax DNA)
        # 1. LIFT (Shebang/Preamble)
        if [ -n "$VLIFT" ]; then
            echo "$VLIFT" > "$TARGET_FILE"
        fi

        # 2. META (Comments)
        PREFIX="$VMUTE"
        if [ -z "$PREFIX" ]; then PREFIX="// "; fi # Fallback if MUTE is missing
        
        HEADER_ACTION=">>"
        if [ -z "$VLIFT" ]; then HEADER_ACTION=">"; fi # Start fresh if no LIFT
        
        eval "echo \"${PREFIX}🛑 QUANTUM STATE: COLLAPSED FROM $(basename "$SOURCE")\" $HEADER_ACTION \"$TARGET_FILE\""
        echo "${PREFIX}🌊 FREQUENCY: $ID | ENERGY: $ENERGY" >> "$TARGET_FILE"
        
        IN_BLOCK=1
        continue
    fi
    
    # Code Block Delimiters
    if [[ "$line" =~ ^\`\`\` ]]; then
        # If we are in a freq block, we toggle the capture state
        if [ $IN_BLOCK -eq 1 ]; then
            if [ $CAPTURING_CODE -eq 1 ]; then
                 # End of code block
                 CAPTURING_CODE=0
                 # We stay in IN_BLOCK (Freq) technically, but we stop writing?
                 # Or do we treat end of code block as end of Freq Block?
                 # Let's assume one code block per Freq Block for now for simplicity.
                 IN_BLOCK=0 
                 TARGET_FILE=""
            else
                 # Start of code block
                 CAPTURING_CODE=1
            fi
        fi
        continue
    fi
    
    # Capture Content
    if [ $IN_BLOCK -eq 1 ] && [ $CAPTURING_CODE -eq 1 ]; then
       echo "$line" >> "$TARGET_FILE"
    fi
    
done < "$SOURCE"

echo "✅ Observation Complete."
