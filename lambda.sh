#!/bin/bash

# λ-Protocol Interpreter v1.1
# Usage: λ <glyph> [args]

GLYPH=$1

# Якщо пустий ввід - показуємо карту
if [ -z "$GLYPH" ]; then GLYPH="map"; else shift; fi

case "$GLYPH" in
    "⊕") # Create / Expand
        ./sh/expand.sh "$@"
        ;;
    "∞"|"loop") # Iterate
        ./sh/loop.sh "$@"
        ;;
    "⋈") # Sync / Join
        echo "🔄 Aligning timelines..."
        git pull && git submodule update --init --recursive
        ;;
    "?"|"map") # Query / Status
        git universe
        ;;
    "Δ") # Change / Commit
        MSG="$@"
        if [ -z "$MSG" ]; then MSG="Δ mutation"; fi
        git add .
        git commit -m "Δ $MSG"
        git push
        ;;
    "⚕️"|"doctor") # Health
        ./sh/doctor.sh
        ;;
    "#") # Executable Comment
        echo "🔮 Executing shadow code..."
        eval "$@"
        ;;
    "🧠"|"brain") # Local AI
        ./sh/brain.sh "$@"
    	;;
    "🧬"|"unfold") # Genetic Projection / Mass Genesis
        ./sh/unfold.sh "$@"
        ;;
    *)
        echo "Unknown glyph: $GLYPH"
        # Передаємо команду в системний git (fallback)
        git $GLYPH "$@"
        ;;
esac