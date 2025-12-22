#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM K.sigma
# 🌊 FREQUENCY: sh | ENERGY: 1
# K (Constant): Ігнорує потік, видає аргумент
# Usage: echo "noise" | K "truth" -> "truth"
K() {
    # Вичитуємо stdin в нікуди (щоб не ламати пайп), виводимо аргумент
    cat > /dev/null
    echo "$1"
}
