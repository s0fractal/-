#!/bin/bash
# s0fractal Synapse v1.0
# Generates System Context for AI Agents

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "--- SYSTEM CONTEXT START ---"
echo "You are the AI Architect of s0fractal."
echo "Current Location: $REPO_ROOT"

# 1. TOPOLOGY (Map)
if command -v tree &> /dev/null; then
    tree -L 2 -d -I '.git|node_modules' "$REPO_ROOT"
else
    find "$REPO_ROOT" -maxdepth 2 -not -path '*/.*' -type d
fi
echo ""

# 2. LEXICON (Protocol)
if [ -f "$REPO_ROOT/md/lexicon/operators.md" ]; then
    echo "### LEXICON (Operators)"
    cat "$REPO_ROOT/md/lexicon/operators.md"
fi
echo ""

# 3. INTENT (Sigma)
if [ -d "$REPO_ROOT/sigma" ]; then
    echo "### SIGMA (DNA)"
    # Show active intents
    find "$REPO_ROOT/sigma" -name "*.sigma" -print -exec head -n 1 {} \;
fi
echo ""

# 4. HEALTH (Doctor)
"$REPO_ROOT/sh/doctor.sh" | grep -v "Scanning"
echo ""

echo "--- SYSTEM CONTEXT END ---"
echo "Instruction: Identify inconsistencies or propose the next λ-action."
