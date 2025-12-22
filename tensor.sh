#!/bin/bash
# s0fractal Tensor Engine v2.0 (Table Topology)
# Parses matrix.sigma Markdown Table. Reliability over Regex.

# Load Context
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
MATRIX_FILE="$REPO_ROOT/sigma/matrix.sigma"

# --- TENSOR STATE ---
# Format: ID|TYPE|PATH|HEX|SYNTAX|MUTE|LIFT
export VECTOR_SPACE=()

# --- LOAD MATRIX ---
if [ -f "$MATRIX_FILE" ]; then
    # We skip headers searching for lines with '|' that are NOT separators (---)
    while read -r line || [ -n "$line" ]; do
        # 1. Must contain '|'
        [[ "$line" == *"|"* ]] || continue
        # 2. Skip separator lines (containing '---')
        [[ "$line" == *"---"* ]] && continue
        # 3. Skip header (containing 'ID' and 'TYPE')
        [[ "$line" == *"ID"* ]] && [[ "$line" == *"TYPE"* ]] && continue
        
        # Parse Matrix table: ID | TYPE | PATH | ...
        # Use awk to split by '|' and trim whitespace/quotes
        IFS='|' read -r ID TYPE PATH_VAL HEX SYNTAX MUTE LIFT <<< "$line"
        
        # Helper function to trim and remove quotes
        clean_val() {
            echo "$1" | xargs | sed 's/^"//; s/"$//'
        }
        
        ID_C=$(clean_val "$ID")
        TYPE_C=$(clean_val "$TYPE")
        PATH_C=$(clean_val "$PATH_VAL")
        HEX_C=$(clean_val "$HEX")
        SYN_C=$(clean_val "$SYNTAX")
        MUTE_C=$(clean_val "$MUTE")
        LIFT_C=$(clean_val "$LIFT")
        
        if [ -n "$ID_C" ]; then
            VECTOR="$ID_C|$TYPE_C|$PATH_C|$HEX_C|$SYN_C|$MUTE_C|$LIFT_C"
            VECTOR_SPACE+=("$VECTOR")
        fi
    done < "$MATRIX_FILE"
fi

# --- TENSOR OPERATIONS ---

# get_vector <id> -> returns full vector string
get_vector() {
    local QUERY_ID=$1
    for VEC in "${VECTOR_SPACE[@]}"; do
        IFS='|' read -r VID VSTO VPATH VSYN VCOL VMUTE VLIFT <<< "$VEC"
        if [[ "$VID" == "$QUERY_ID" ]]; then
            echo "$VEC"
            return
        fi
    done
}

# project <property_index> -> returns array of all values for that property
# 0=ID, 1=TYPE, 2=PATH, 3=HEX, 4=SYNTAX, 5=MUTE, 6=LIFT
project_dim() {
    local IDX=$1
    for VEC in "${VECTOR_SPACE[@]}"; do
        IFS='|' read -ra PARTS <<< "$VEC"
        echo "${PARTS[$IDX]}"
    done
}

# --- ENVIRONMENT EXPORT ---
# Expose ALL_DIMS and ALL_LAYERS for loop.sh and other tools
export ALL_DIMS=($(project_dim 0))
export ALL_LAYERS=(0 1 2 3 4 5 6 7 8)