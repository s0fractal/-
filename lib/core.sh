#!/bin/bash
# 🌌 s0fractal Shell Combinators Core
# Standard library of stream-based physics.

# Identity (I)
I() {
    cat -
}

# Constant (K)
K() {
    cat > /dev/null
    echo "$1"
}

# Witness/Fork (W)
W() {
    local TARGET=$1
    if [ -z "$TARGET" ]; then
        tee
    else
        tee "$TARGET"
    fi
}

# Effect (E)
E() {
    local MSG=$1
    while IFS= read -r line; do
        echo "⚡ $MSG: $line" >&2
        echo "$line"
    done
}

# Sleep (Z)
Z() {
    sleep $1
    cat -
}

# Export for subshells
export -f I K W E Z
