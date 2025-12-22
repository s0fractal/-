#!/bin/bash
# s0fractal HUD v1.0
# Displays the current state of the Void

# --- SPECTRUM PALETTE (ANSI) ---
C_RESET='\033[0m'
C_VOID='\033[1;30m'   # Void (Black/Dark Grey)
C_LIGHT='\033[1;37m'  # Light (White)
C_TS='\033[1;34m'     # TS (Blue)
C_RS='\033[1;31m'     # RS (Red)
C_SH='\033[1;32m'     # SH (Green)
C_LEAN='\033[1;33m'   # LEAN (Gold)
C_MD='\033[0;37m'     # MD (Grey)

# --- TELEMETRY ---
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
BRANCH=$(git branch --show-current 2>/dev/null)
USER_HOST=$(whoami)@$(hostname)

# Doctor Pulse (Short version)
STATUS_ICON="🟢"
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then STATUS_ICON="🟡"; fi

# --- RENDER ---
clear
echo -e "${C_VOID}┌──────────────────────────────────────────────────────────────┐${C_RESET}"
echo -e "${C_VOID}│${C_RESET}  ${C_LIGHT}Σ s0fractal${C_RESET} ${C_VOID}::${C_RESET} ${C_SH}System Active${C_RESET}                                ${C_VOID}│${C_RESET}"
echo -e "${C_VOID}├──────────────────────────────────────────────────────────────┤${C_RESET}"
echo -e "${C_VOID}│${C_RESET}  ${C_MD}IDENTITY :${C_RESET}  ${USER_HOST} "
echo -e "${C_VOID}│${C_RESET}  ${C_MD}LOCUS    :${C_RESET}  ${REPO_ROOT##*/} ${C_VOID}(${BRANCH})${C_RESET} ${STATUS_ICON}"
echo -e "${C_VOID}│${C_RESET}                                                            ${C_VOID}│${C_RESET}"
echo -e "${C_VOID}│${C_RESET}  ${C_MD}SPECTRUM :${C_RESET}  ${C_TS}● TS${C_RESET}  ${C_RS}● RS${C_RESET}  ${C_SH}● SH${C_RESET}  ${C_LEAN}● LEAN${C_RESET}  ${C_MD}● MD${C_RESET}                ${C_VOID}│${C_RESET}"
echo -e "${C_VOID}│${C_RESET}  ${C_MD}PROTOCOL :${C_RESET}  ${C_LIGHT}λ${C_RESET} awaiting input...                          ${C_VOID}│${C_RESET}"
echo -e "${C_VOID}└──────────────────────────────────────────────────────────────┘${C_RESET}"
echo ""
