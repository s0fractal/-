#!/bin/bash
# Generates a Topology Map (Mermaid format)

echo "graph TD"
echo "    ROOT[$PWD]"

git submodule status --recursive | while read -r line; do
    # SHA path (tag)
    SHA=$(echo $line | awk '{print $1}' | sed 's/+//;s/-//')
    PATH_NAME=$(echo $line | awk '{print $2}')
    
    # Визначаємо батька по шляху (дуже спрощено)
    PARENT="ROOT"
    if [[ "$PATH_NAME" == *"/"* ]]; then
        PARENT=$(dirname "$PATH_NAME")
    fi
    
    # Малюємо зв'язок
    echo "    $PARENT --> $PATH_NAME"
done
