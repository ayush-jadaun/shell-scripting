cho "=== Interactive Menu System ==="

# Function to display menu
show_menu() {
    echo -e "\n==== MAIN MENU ===="
    echo "1. Show system information"
    echo "2. List files in current directory"
    echo "3. Calculator"
    echo "4. Password generator"
    echo "5. Process monitor"
    echo "6. Exit"
    echo -n "Enter your choice [1-6]: "
}

# System information function
show_system_info() {
    echo -e "\n=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "Current user: $USER"
    echo "Current date: $(date)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo "Disk usage:"
    df -h / 2>/dev/null | tail -1 || echo "Unable to get disk info"
    echo "Memory usage:"
    free -h 2>/dev/null || echo "Unable to get memory info"
}

# Simple calculator function
calculator() {
    echo -e "\n=== Simple Calculator ==="
    read -p "Enter first number: " num1
    read -p "Enter operator (+, -, *, /): " op
    read -p "Enter second number: " num2
    
    if ! [[ $num1 =~ ^-?[0-9]+\.?[0-9]*$ ]] || ! [[ $num2 =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        echo "Error: Invalid numbers entered"
        return 1
    fi
    
    case $op in
        +) result=$(echo "$num1 + $num2" | bc 2>/dev/null || echo "$((num1 + num2))") ;;
        -) result=$(echo "$num1 - $num2" | bc 2>/dev/null || echo "$((num1 - num2))") ;;
        *) result=$(echo "$num1 * $num2" | bc 2>/dev/null || echo "$((num1 * num2))") ;;
        /) 
            if [ "$num2" == "0" ]; then
                echo "Error: Division by zero"
                return 1
            fi
            result=$(echo "scale=2; $num1 / $num2" | bc 2>/dev/null || echo "$((num1 / num2))")
            ;;
        *) echo "Error: Invalid operator"; return 1 ;;
    esac
    
    echo "Result: $num1 $op $num2 = $result"
}

# Password generator function
generate_password() {
    echo -e "\n=== Password Generator ==="
    read -p "Enter password length (8-32): " length
    
    if ! [[ $length =~ ^[0-9]+$ ]] || [ "$length" -lt 8 ] || [ "$length" -gt 32 ]; then
        echo "Error: Please enter a number between 8 and 32"
        return 1
    fi
    
    # Generate password using /dev/urandom and tr
    password=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c "$length")
    echo "Generated password: $password"
}

# Process monitor function
process_monitor() {
    echo -e "\n=== Process Monitor ==="
    echo "Top 10 processes by CPU usage:"
    ps aux --sort=-%cpu | head -11
    
    echo -e "\nTop 10 processes by memory usage:"
    ps aux --sort=-%mem | head -11
}

# Main menu loop
while true; do
    show_menu
    read choice
    
    case $choice in
        1) show_system_info ;;
        2) echo -e "\n=== Files in current directory ==="; ls -la ;;
        3) calculator ;;
        4) generate_password ;;
        5) process_monitor ;;
        6) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
    
    echo -e "\nPress Enter to continue..."
    read
done

