#!/bin/bash
# s0fractal Tensor Engine v1.0
# Parses the Matrix. Logic over Labels.

# Load Context
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
MATRIX_FILE="$REPO_ROOT/sigma/matrix.sigma"

# --- TENSOR STATE ---
# Ми зберігаємо вектори як рядки з роздільником "|"
# Format: ID|STORAGE|PATH|SYNTAX|HEX
export VECTOR_SPACE=()

# --- LOAD MATRIX ---
if [ -f "$MATRIX_FILE" ]; then
    while read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue
        
        # Parse Matrix syntax: [ id, storage, ... ]
        # 1. Check if line starts with "["
        if [[ "$line" =~ ^\[ ]]; then
             # Remove "[" and "]"
             CLEAN=$(echo "$line" | sed 's/^\[//; s/\]//')
             
             # 2. Split by comma
             IFS=',' read -r ID STORAGE PATH_VAL SYNTAX COLOR <<< "$CLEAN"
             
             # Trim spaces
             ID=$(echo "$ID" | xargs)
             STORAGE=$(echo "$STORAGE" | xargs)
             PATH_VAL=$(echo "$PATH_VAL" | xargs)
             SYNTAX=$(echo "$SYNTAX" | xargs)
             COLOR=$(echo "$COLOR" | xargs)
             
             # Store as Vector
             VECTOR="$ID|$STORAGE|$PATH_VAL|$SYNTAX|$COLOR"
             VECTOR_SPACE+=("$VECTOR")
        fi
    done < "$MATRIX_FILE"
fi

# --- TENSOR OPERATIONS ---

# get_vector <id> -> returns full vector string
get_vector() {
    local QUERY_ID=$1
    for VEC in "${VECTOR_SPACE[@]}"; do
        IFS='|' read -r VID VSTO VPATH VSYN VCOL <<< "$VEC"
        if [[ "$VID" == "$QUERY_ID" ]]; then
            echo "$VEC"
            return
        fi
    done
}

# project <property_index> -> returns array of all values for that property
# 0=ID, 1=STORAGE, 2=PATH, 3=SYNTAX, 4=COLOR
project_dim() {
    local IDX=$1
    for VEC in "${VECTOR_SPACE[@]}"; do
        IFS='|' read -ra PARTS <<< "$VEC"
        echo "${PARTS[$IDX]}"
    done
}