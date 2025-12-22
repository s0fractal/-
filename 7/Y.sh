#!/bin/bash
# 🛑 QUANTUM STATE: COLLAPSED FROM Y.sigma
# 🌊 FREQUENCY: sh | ENERGY: 7
# Y-Pattern for Bash: The "Fixed Point" Wrapper
# Usage: Y <function_name> <args>

Y() {
    local FUNC=$1
    shift
    local ARGS="$@"
    
    # The Fixed Point: Infinite Loop protected by Exit Code
    while true; do
        $FUNC $ARGS
        
        # Break the recursion if the function returns non-zero
        if [ $? -ne 0 ]; then break; fi
        
        # Breathe (anti-spin lock)
        sleep 1
    done
}
