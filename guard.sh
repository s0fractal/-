#!/bin/bash
# s0fractal Structure Guard v1.0
# Enforces the Laws of Topology. Auto-corrects if flag --fix is passed.

FIX_MODE=0
if [[ "$1" == "--fix" ]]; then FIX_MODE=1; fi

REPO_ROOT=$(git rev-parse --show-toplevel)
ERRORS=0

log_err() { echo "❌ RULE BROKEN: $1"; ((ERRORS++)); }
log_fix() { echo "   🛠  FIXING: $1"; }

echo "🛡️  Guarding the Void..."

# RULE 1: NO CODE IN VOID ROOT
# У корені ~/void не має бути ніяких .ts, .rs файлів. Тільки папки та .md
FORBIDDEN_FILES=$(find "$REPO_ROOT" -maxdepth 1 -name "*.ts" -o -name "*.rs" -o -name "*.js")

if [ -n "$FORBIDDEN_FILES" ]; then
    log_err "Code found in Void Root (Must be in nodes/)"
    echo "$FORBIDDEN_FILES"
    
    if [ $FIX_MODE -eq 1 ]; then
        # Евристика: якщо це код, кидаємо його в intents/drafts
        mkdir -p "$REPO_ROOT/intents/drafts"
        mv $FORBIDDEN_FILES "$REPO_ROOT/intents/drafts/"
        log_fix "Moved stray code to intents/drafts/"
    fi
fi

# RULE 2: NODES MUST BE SUBMODULES
# Перевіряємо, чи папки в nodes/ є реальними гіт-репо
if [ -d "$REPO_ROOT/nodes" ]; then
    for node in "$REPO_ROOT/nodes"/*; do
        if [ -d "$node" ] && [ ! -f "$node/.git" ]; then
            log_err "Node $(basename "$node") is a raw folder, not a submodule!"
            # Тут автофікс складний, бо треба знати URL, тому просто кричимо
        fi
    done
fi

# RULE 3: GLYPHS INTEGRITY
# Перевіряємо, чи є папки lexicon, crystal, intents
for zone in lexicon crystal intents; do
    if [ ! -d "$REPO_ROOT/glyphs/$zone" ]; then
        log_err "Missing Glyph Zone: $zone"
        if [ $FIX_MODE -eq 1 ]; then
            mkdir -p "$REPO_ROOT/glyphs/$zone"
            touch "$REPO_ROOT/glyphs/$zone/.keep"
            log_fix "Created $zone"
        fi
    fi
done

# RULE 4: NO README IN CODE DIMENSIONS
# README.md дозволені тільки в корені та в sigma/. Решта - шум.
SHADOW_READMES=$(find "$REPO_ROOT/ts" "$REPO_ROOT/rs" "$REPO_ROOT/lean" -name "README.md" 2>/dev/null)
if [ -n "$SHADOW_READMES" ]; then
    log_err "Shadow READMEs found in code dimensions (Noise detected)"
    echo "$SHADOW_READMES"
    if [ $FIX_MODE -eq 1 ]; then
        echo "$SHADOW_READMES" | xargs rm
        log_fix "Purged shadow READMEs."
    fi
fi

if [ $ERRORS -eq 0 ]; then
    echo "✅ Structure is Sacred."
else
    echo "⚠️  Found $ERRORS violations."
    if [ $FIX_MODE -eq 0 ]; then echo "   Run with --fix to attempt auto-repair."; fi
    exit 1
fi
```

### Як це інтегрувати в `lambda.sh`

Додай новий гліф `🛡️` (Guard) у свій інтерпретатор.

```bash
    "🛡️"|"guard")
        ./sh/guard.sh "$@" ;;
