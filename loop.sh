#!/bin/bash
# s0fractal Iterator v1.0
# Usage: λ loop <set> <command>
# Example: λ loop dims "git status -s"

# Load Context
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/env.sh"
source "$SCRIPT_DIR/tables.sh"

TARGET_SET=$1
CMD_TEMPLATE=$2

if [ -z "$TARGET_SET" ] || [ -z "$CMD_TEMPLATE" ]; then
    echo "Usage: loop [dims|layers] 'command'"
    echo "Sets: dims (${ALL_DIMS[*]}), layers (${ALL_LAYERS[*]})"
    exit 1
fi

# Вибираємо множину для ітерації
ITERABLE=()
if [ "$TARGET_SET" == "dims" ]; then
    ITERABLE=("${ALL_DIMS[@]}")
elif [ "$TARGET_SET" == "layers" ]; then
    ITERABLE=("${ALL_LAYERS[@]}")
else
    echo "❌ Unknown set: $TARGET_SET"
    exit 1
fi

echo "🔄 Looping over $TARGET_SET..."

for ITEM in "${ITERABLE[@]}"; do
    # Обчислюємо шлях
    if [ "$TARGET_SET" == "dims" ]; then
        WORK_DIR="$REPO_ROOT/$ITEM"
        COLOR=$(get_color "$ITEM")
    else
        # ...
        WORK_DIR="$REPO_ROOT" 
        COLOR="\033[1;37m"
    fi
    
    # If no color found, default to white
    if [ -z "$COLOR" ]; then COLOR="\033[1;37m"; fi

    # Перевіряємо існування
    if [ -d "$WORK_DIR" ]; then
        echo -e "${COLOR}>>> [$ITEM]${NC}"
        
        # Виконуємо команду в контексті папки
        (cd "$WORK_DIR" && eval "$CMD_TEMPLATE")
        
        echo ""
    else
        # Optional: Warn if dimension is missing
        # echo -e "${COLOR}>>> [$ITEM] (Mirage/Missing)${NC}"
        :
    fi
done
