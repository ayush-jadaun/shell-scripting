#!/bin/bash

# for and while loop

# Create directories using a for loop
for (( i=0; i<5; i++ )); do
    mkdir "demo ${i}"
    ls
done

ls

# Delete directories using a for loop
for (( i=0; i<5; i++ )); do
    rm -r "demo ${i}"
    ls
done

# Add a while loop
echo "Starting while loop..."
count=0

while [ $count -lt 3 ]; do
    echo "While loop iteration: $count"
    ((count++))  # increment
done

echo "While loop finished."



