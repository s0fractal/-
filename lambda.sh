#!/bin/bash

# λ-Protocol Interpreter
# Usage: λ <glyph> [args]

GLYPH=$1
shift

case "$GLYPH" in
    "⚕️"|"doctor")
        ./sh/doctor.sh
        ;;

    "⊕") # Create / Expand
        ./sh/expand.sh "$@"
        ;;
    "⋈") # Sync / Join
        echo "🔄 Aligning timelines..."
        git pull && git submodule update --init --recursive
        ;;
    "?") # Query / Status
        git universe
        ;;
    "Δ") # Change / Commit
        # λ Δ "message" -> git commit -am "Δ: message" && git push
        MSG="$@"
        if [ -z "$MSG" ]; then MSG="Δ mutation"; fi
        git add .
        git commit -m "Δ $MSG"
        git push
        ;;
    "#") # Executable Comment (Твоя ідея!)
        # λ # echo "Hello" -> executes "echo Hello"
        echo "🔮 Executing shadow code..."
        eval "$@"
        ;;
    *)
        echo "Unknown glyph: $GLYPH"
        echo "Try: ⊕ (expand), ⋈ (sync), ? (map), Δ (save)"
        ;;
esac
