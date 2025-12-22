#!/bin/bash
GLYPH=$1
# Якщо пустий ввід - показуємо карту
if [ -z "$GLYPH" ]; then GLYPH="map"; else shift; fi

case "$GLYPH" in
    "⊕") # Create
        ./sh/expand.sh "$@" ;;
    "⋈") # Sync
        echo "🔄 Aligning timelines..."
        git pull && git submodule update --init --recursive ;;
    "?"|"map") # Map
        git universe ;;
    "Δ") # Save
        MSG="$@"
        if [ -z "$MSG" ]; then MSG="Δ mutation"; fi
        git add .
        git commit -m "Δ $MSG"
        git push ;;
    "⚕️"|"doctor") # Health
        ./sh/doctor.sh ;;
    "#") # Exec
        eval "$@" ;;
    *) # Passthrough
        git $GLYPH "$@" ;;
esac
