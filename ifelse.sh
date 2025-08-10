#!/bin/bash

: << 'disclaimer'
This is a disclaimer
disclaimer

read -p "Enter first number: " first
read -p "Enter second number: " second

if (( first > second )); then
    echo "First is greater"
else
    echo "Second is greater"
fi

