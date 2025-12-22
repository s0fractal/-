#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM E.sigma
# 🌊 FREQUENCY: sh | ENERGY: 1
# E (Effect/Side-Effect): Робить щось (виводить в stderr), не ламаючи потік
# Usage: echo "data" | E "Processing..." | ...
E() {
    local MSG=$1
    # Читаємо потік рядок за рядком
    while IFS= read -r line; do
        # Робимо ефект (наприклад, лог в stderr)
        echo "⚡ $MSG: $line" >&2
        # Пропускаємо дані далі (Identity)
        echo "$line"
    done
}
