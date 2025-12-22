#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM W.sigma
# 🌊 FREQUENCY: sh | ENERGY: 2
# W (Fork/Witness): Дублює потік у файл або процес, повертає потік далі
# Usage: echo "data" | W "log.txt" | ...
W() {
    local TARGET=$1
    if [ -z "$TARGET" ]; then
        tee # Просто дублює в stdout (подвійний потік)
    else
        tee "$TARGET"
    fi
}
