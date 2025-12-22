#!/bin/bash
# s0fractal Unfolder v1.0
# Collapses the entire Sigma Field into Material Reality.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🧬 Engaging Unfold Protocol..."

# Iterate over all .sigma files in the root of sigma/
for particle in "$REPO_ROOT/sigma"/*.sigma; do
    # Skip matrix.sigma
    if [[ "$particle" == *"matrix.sigma" ]]; then continue; fi
    
    "$SCRIPT_DIR/genesis.sh" "$particle"
done

echo "✅ Universe Synchronized."
