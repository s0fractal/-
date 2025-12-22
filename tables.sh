#!/bin/bash
# s0fractal Registry Tables
# Defines the iterable sets of the Universe

# --- CONSTANTS ---
# Dimensions
D_SIGMA="sigma" # DNA / Intent
D_TS="ts"       # Logic
D_RS="rs"       # Force
D_SH="sh"       # Action
D_RB="rb"       # Crystal
D_LEAN="lean"   # Proof
D_MD="md"       # Chronicles
D_DNA="🧬"      # Pure Source

# Layers
L_0="0"         # Identity
L_1="1"         # Matter
L_2="2"         # Structure
L_6="6"         # Surface

# --- TABLES ---

# 1. DIMENSIONS (The Spectrum)
# Порядок має значення: від Духу до Матерії
export ALL_DIMS=(
    "$D_DNA"
    "$D_SIGMA"
    "$D_MD"
    "$D_TS"
    "$D_RS"
    "$D_LEAN"
    "$D_SH"
    "$D_RB"
)
# Note: User request didn't explicitly list 'lean', 'md', 'DNA' in their sample code, 
# but they exist in the file system now. I should include them if they are dimensions.
# User sample: sigma ts rs sh rb.
# But previously I added md, dna, lean. I will include ALL existing ones for completeness.

# 2. LAYERS (The Depth)
export ALL_LAYERS=(
    "$L_0"
    "$L_1"
    "$L_2"
    "$L_6"
)

# --- 3. COLORS (Function for UI) ---
# Cannot use declare -A on standard macOS Bash (3.x)
get_color() {
    local ID=$1
    case "$ID" in
        "$D_DNA")   echo "\033[1;35m" ;; # Magenta (Deep)
        "$D_SIGMA") echo "\033[0;35m" ;; # Magenta
        "$D_MD")    echo "\033[0;37m" ;; # White
        "$D_TS")    echo "\033[1;34m" ;; # Blue
        "$D_RS")    echo "\033[1;31m" ;; # Red
        "$D_LEAN")  echo "\033[1;33m" ;; # Gold
        "$D_SH")    echo "\033[1;32m" ;; # Green
        "$D_RB")    echo "\033[0;33m" ;; # Yellow
        *)          echo "\033[1;37m" ;; # Default White
    esac
}
export -f get_color
