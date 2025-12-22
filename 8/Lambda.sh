#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM Lambda.sigma
# 🌊 FREQUENCY: sh | ENERGY: 8
# λ-Protocol Interpreter v1.2 (Self-Hosted)
# Usage: λ <glyph> [args]

GLYPH=$1

# Якщо пустий ввід - показуємо карту
if [ -z "$GLYPH" ]; then GLYPH="map"; else shift; fi

case "$GLYPH" in
    "⊕") # Create / Expand (Sprout)
        ./sh/8/Sprout.sh "$@"
        ;;
    "∞"|"loop") # Iterate (Loop)
        ./sh/8/Loop.sh "$@"
        ;;
    "⋈") # Sync / Join
        echo "🔄 Aligning timelines..."
        git pull && git submodule update --init --recursive
        ;;
    "?"|"map"|"synapse") # Query / Status (Synapse)
        ./sh/8/Synapse.sh "$@"
        ;;
    "Δ") # Change / Commit
        MSG="$@"
        if [ -z "$MSG" ]; then MSG="Δ mutation"; fi
        git add .
        git commit -m "Δ $MSG"
        git push
        ;;
    "⚕️"|"doctor") # Health (Doctor)
        ./sh/8/Doctor.sh "$@"
        ;;
    "#") # Executable Comment
        echo "🔮 Executing shadow code..."
        eval "$@"
        ;;
    "🧠"|"brain") # Local AI
        ./sh/brain.sh "$@"
    	;;
    "🧬"|"unfold"|"sync") # Genetic Projection / Mass Genesis (Sync)
        ./sh/8/Sync.sh "$@"
        ;;
    "⚡"|"genesis") # Wave Collapse (Genesis)
        ./sh/8/Genesis.sh "$@"
        ;;
    "Y"|"process") # Recursion / Daemon
        source ./sh/7/Y.sh
        Y "$@"
        ;;
    *)
        # Передаємо команду в системний git (fallback)
        git $GLYPH "$@"
        ;;
esac
