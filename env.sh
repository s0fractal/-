#!/bin/bash
# s0fractal Environment

# Root Detection
if [ -d ".git" ]; then
    export REPO_ROOT="$PWD"
else
    export REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
fi

# Colors
export NC='\033[0m' # No Color
