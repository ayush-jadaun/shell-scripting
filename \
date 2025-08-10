#!/bin/bash
#
# Script to learn functions and take arguments
#

# Function to add two numbers
function add() {
    local a=$1
    local b=$2

    # Check if both arguments are numbers
    if ! [[ $a =~ ^-?[0-9]+$ && $b =~ ^-?[0-9]+$ ]]; then
        echo "Error: Both arguments must be integers."
        return 1
    fi

    local sum=$((a + b))
    echo "Sum: $sum"
}

# Check if exactly two arguments are passed to the script
if [ $# -ne 2 ]; then
    echo "Usage: $0 <number1> <number2>"
    exit 1
fi

# Call the function with command-line arguments
add $1 $2

