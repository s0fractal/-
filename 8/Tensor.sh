#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM Tensor.sigma
# 🌊 FREQUENCY: sh | ENERGY: 8
# s0fractal Tensor Engine v2.1 (Self-Hosted)
# Load Context
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
MATRIX_FILE="$REPO_ROOT/sigma/matrix.sigma"

# --- TENSOR STATE ---
export VECTOR_SPACE=()

# --- LOAD MATRIX (Combinator Pipeline) ---
# 1. Читаємо файл
# 2. Фільтруємо таблицю
# 3. Форматуємо вектори
# 4. Колапсуємо в масив

_load_matrix() {
    if [ ! -f "$MATRIX_FILE" ]; then return 1; fi

    while IFS= read -r vec; do
        VECTOR_SPACE+=("$vec")
    done < <(cat "$MATRIX_FILE" | \
        grep "|" | \
        grep -v "\-\-\-" | \
        grep -v "ID" | \
        while IFS='|' read -r id type path hex syn mute lift; do
            # Clean values using Identity combinator pattern if needed, 
            # but here we just need raw strings.
            echo "$(echo $id | xargs)|$(echo $type | xargs)|$(echo $path | xargs)|$(echo $hex | xargs)|$(echo $syn | xargs)|$(echo $mute | xargs | sed 's/^\"//; s/\"$//')|$(echo $lift | xargs | sed 's/^\"//; s/\"$//')"
        done)
}

_load_matrix

# --- TENSOR OPERATIONS ---

# get_vector <id>
get_vector() {
    local QUERY_ID=$1
    for VEC in "${VECTOR_SPACE[@]}"; do
        if [[ "$(echo "$VEC" | cut -d'|' -f1)" == "$QUERY_ID" ]]; then
            echo "$VEC"
            return
        fi
    done
}

# project_dim <index>
project_dim() {
    local IDX=$(( $1 + 1 ))
    for VEC in "${VECTOR_SPACE[@]}"; do
        echo "$VEC" | cut -d'|' -f$IDX
    done
}

# --- ENVIRONMENT EXPORT ---
export ALL_DIMS=($(project_dim 0))
export ALL_LAYERS=(0 1 2 3 4 5 6 7 8)
