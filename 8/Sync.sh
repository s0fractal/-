#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM Sync.sigma
# 🌊 FREQUENCY: sh | ENERGY: 8
# s0fractal Sync v1.0 (Universe Synchronizer)
# Generated from Sync.sigma

source "$(dirname "${BASH_SOURCE[0]}")/tensor.sh"
λ() { "$REPO_ROOT/sh/lambda.sh" "$@"; }

echo "🧬 Engaging Alignment..."

# Iterate over all particles in the Sigma field
for particle in "$REPO_ROOT/sigma"/*.sigma; do
    # Skip the matrix itself as it is the source of truth for the tensor, not a collapse-target
    [[ "$particle" == *"matrix.sigma" ]] && continue
    
    λ ⚡ "$particle"
done

echo "✅ Universe Synchronized."
