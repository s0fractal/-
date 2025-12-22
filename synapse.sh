#!/bin/bash
# s0fractal Synapse v1.0
# Generates System Context for AI Agents

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "--- SYSTEM CONTEXT START ---"
echo "You are the AI Architect of s0fractal."
echo "Current Location: $REPO_ROOT"
echo ""

echo "### 1. TOPOLOGY (Structure)"
# Якщо є tree, показуємо дерево, якщо ні - ls
if command -v tree &> /dev/null; then
    tree -L 3 -I '.git|node_modules' "$REPO_ROOT"
else
    find "$REPO_ROOT" -maxdepth 3 -not -path '*/.*'
fi
echo ""

echo "### 2. LEXICON (Protocol)"
if [ -f "$REPO_ROOT/glyphs/lexicon/operators.md" ]; then
    cat "$REPO_ROOT/glyphs/lexicon/operators.md"
fi
echo ""

echo "### 3. SPECTRUM (Colors)"
if [ -f "$REPO_ROOT/glyphs/lexicon/spectrum.md" ]; then
    cat "$REPO_ROOT/glyphs/lexicon/spectrum.md"
fi
echo ""

echo "### 4. HEALTH (Doctor)"
"$REPO_ROOT/sh/doctor.sh" | grep -v "Scanning"
echo ""

echo "--- SYSTEM CONTEXT END ---"
echo "Instruction: Identify inconsistencies or propose the next λ-action."
