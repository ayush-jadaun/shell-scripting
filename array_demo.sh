#!/bin/bash

echo "=== Array Demo Script ==="

# Declare arrays
fruits=("apple" "banana" "orange" "grape" "mango")
numbers=(10 25 30 45 50)

echo "All fruits: ${fruits[@]}"
echo "Number of fruits: ${#fruits[@]}"
echo "First fruit: ${fruits[0]}"
echo "Last fruit: ${fruits[-1]}"

# Loop through array
echo -e "\nLooping through fruits:"
for i in "${!fruits[@]}"; do
    echo "Index $i: ${fruits[$i]}"
done

# Array operations
fruits+=("pineapple")  # Add element
echo -e "\nAfter adding pineapple: ${fruits[@]}"

# Remove element
unset fruits[1]  # Remove banana
echo "After removing banana: ${fruits[@]}"

# Find sum of numbers array
total=0
for num in "${numbers[@]}"; do
    total=$((total + num))
done
echo -e "\nSum of numbers: $total"
