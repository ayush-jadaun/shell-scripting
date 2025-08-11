# Shell Scripting Learning Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [File Permissions and chmod](#file-permissions-and-chmod)
4. [Basic Shell Scripting Concepts](#basic-shell-scripting-concepts)
5. [Variables](#variables)
6. [User Input](#user-input)
7. [Conditional Statements](#conditional-statements)
8. [Functions](#functions)
9. [Command-Line Arguments](#command-line-arguments)
10. [Loops](#loops)
11. [Error Handling](#error-handling)
12. [Best Practices](#best-practices)

## Introduction

Shell scripting is a powerful way to automate tasks in Unix/Linux systems. This guide will teach you the fundamentals of bash scripting through practical examples.

## Getting Started

### The Shebang Line
Every shell script should start with a shebang (`#!`) line:
```bash
#!/bin/bash
```
This tells the system which interpreter to use to execute the script.

### Making Scripts Executable
Before running a script, you need to make it executable using the `chmod` command.

## File Permissions and chmod

### Understanding File Permissions

In Unix/Linux systems, every file and directory has three types of permissions for three categories of users:

#### Permission Types:
- **Read (r)**: Permission to read the file (value: 4)
- **Write (w)**: Permission to modify the file (value: 2)
- **Execute (x)**: Permission to run the file as a program (value: 1)

#### User Categories:
- **Owner (User)**: The person who owns the file
- **Group**: Users who belong to the file's group
- **Other**: Everyone else

### chmod Command Syntax
```bash
chmod [permissions] [filename]
```

### Numeric Permissions Table

| Number | Binary | Permissions | Description |
|--------|--------|-------------|-------------|
| 0      | 000    | ---         | No permissions |
| 1      | 001    | --x         | Execute only |
| 2      | 010    | -w-         | Write only |
| 3      | 011    | -wx         | Write and execute |
| 4      | 100    | r--         | Read only |
| 5      | 101    | r-x         | Read and execute |
| 6      | 110    | rw-         | Read and write |
| 7      | 111    | rwx         | Read, write, and execute |

### Common chmod Examples

| Command | Owner | Group | Other | Description |
|---------|-------|-------|-------|-------------|
| chmod 755 | rwx (7) | r-x (5) | r-x (5) | Owner: full access, Group/Other: read and execute |
| chmod 644 | rw- (6) | r-- (4) | r-- (4) | Owner: read/write, Group/Other: read only |
| chmod 777 | rwx (7) | rwx (7) | rwx (7) | Everyone: full access (dangerous!) |
| chmod 600 | rw- (6) | --- (0) | --- (0) | Owner only: read/write |
| chmod 754 | rwx (7) | r-x (5) | r-- (4) | Owner: full, Group: read/execute, Other: read only |

### How to Read chmod 755
- **First digit (7)**: Owner permissions = 4+2+1 = read+write+execute
- **Second digit (5)**: Group permissions = 4+1 = read+execute
- **Third digit (5)**: Other permissions = 4+1 = read+execute

### Making Scripts Executable
```bash
# Make script executable for owner only
chmod 755 script.sh

# Alternative: using symbolic notation
chmod +x script.sh
```

## Basic Shell Scripting Concepts

### Comments
```bash
# Single line comment

: << 'comment'
Multi-line comment
You can write multiple lines here
comment

<< comment
Another way for multi-line comments
comment
```

## Variables

### Variable Declaration and Usage
```bash
#!/bin/bash

# Variable assignment (no spaces around =)
name="ayush"

# Using variables with curly braces (recommended)
echo "Name is ${name}"

# Simple variable usage
echo "Name is $name"
```

**Key Points:**
- No spaces around the `=` sign
- Use `${variable}` for clarity and to avoid ambiguity
- Variables are case-sensitive

## User Input

### Reading User Input
```bash
# Simple read
echo "Enter another name"
read name

# Read with prompt
read -p "Enter name: " name

# Read with prompt for numbers
read -p "Enter first number: " first
read -p "Enter second number: " second
```

## Conditional Statements

### if-elif-else Structure
```bash
#!/bin/bash

read -p "Enter first number: " first
read -p "Enter second number: " second

if (( first > second )); then
    echo "First is greater"
elif (( first == second )); then
    echo "Both are equal"
else
    echo "Second is greater"
fi
```

### Comparison Operators
- `(( a > b ))`: Arithmetic comparison
- `[ $a -gt $b ]`: Numeric comparison
- `[ "$a" = "$b" ]`: String comparison
- `[ -f filename ]`: File exists
- `[ -d dirname ]`: Directory exists

## Functions

### Function Definition and Usage
```bash
#!/bin/bash

# Function definition
function add() {
    local a=$1  # First parameter
    local b=$2  # Second parameter
    
    # Input validation
    if ! [[ $a =~ ^-?[0-9]+$ && $b =~ ^-?[0-9]+$ ]]; then
        echo "Error: Both arguments must be integers."
        return 1
    fi
    
    local sum=$((a + b))
    echo "Sum: $sum"
}

# Function call
add 5 3
```

**Key Points:**
- Use `local` variables inside functions
- `$1, $2, $3...` represent function parameters
- `return` statement exits the function with a status code

## Command-Line Arguments

### Accessing Script Arguments
```bash
#!/bin/bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "Number of arguments: $#"

# Check argument count
if [ $# -ne 2 ]; then
    echo "Usage: $0 <number1> <number2>"
    exit 1
fi
```

**Special Variables:**
- `$0`: Script name
- `$1, $2, $3...`: Positional parameters
- `$@`: All arguments
- `$#`: Number of arguments
- `$$`: Process ID

## Loops

### For Loop
```bash
#!/bin/bash

# C-style for loop
for (( i=0; i<5; i++ )); do
    echo "Iteration: $i"
    mkdir "demo_${i}"
done

# For loop with range
for i in {1..5}; do
    echo "Number: $i"
done

# For loop with list
for name in Alice Bob Charlie; do
    echo "Hello, $name!"
done
```

### While Loop
```bash
#!/bin/bash

count=0
while [ $count -lt 3 ]; do
    echo "While loop iteration: $count"
    ((count++))  # Increment counter
done
```

## Error Handling

### Basic Error Handling
```bash
#!/bin/bash

create_directory() {
    mkdir demo
}

# Check if command succeeded
if ! create_directory; then
    echo "Error: Directory creation failed"
    exit 1
fi

echo "Directory created successfully"
```

### Error Handling Best Practices
```bash
# Exit on any error
set -e

# Exit on undefined variables
set -u

# Make pipe failures cause script to fail
set -o pipefail

# Combine all three
set -euo pipefail
```

## Best Practices

### 1. Script Structure
```bash
#!/bin/bash
set -euo pipefail

# Script description and usage
# Author: Your Name
# Date: YYYY-MM-DD

# Global variables
SCRIPT_DIR="$(dirname "$0")"
LOG_FILE="/var/log/script.log"

# Functions
function main() {
    # Main script logic here
}

# Call main function
main "$@"
```

### 2. Variable Naming
- Use descriptive names: `user_count` instead of `uc`
- Use uppercase for constants: `MAX_RETRIES=3`
- Quote variables: `"$variable"` to prevent word splitting

### 3. Error Messages
```bash
function error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Usage
[ -f "$config_file" ] || error_exit "Config file not found: $config_file"
```

### 4. Input Validation
```bash
function validate_number() {
    local number=$1
    if ! [[ $number =~ ^[0-9]+$ ]]; then
        error_exit "Invalid number: $number"
    fi
}
```

## Running Scripts

### Step-by-step Process
1. **Create the script**: `nano myscript.sh`
2. **Add shebang**: `#!/bin/bash`
3. **Write your code**
4. **Save the file**
5. **Make executable**: `chmod 755 myscript.sh`
6. **Run the script**: `./myscript.sh`

### Alternative Execution Methods
```bash
# Direct execution (if executable)
./script.sh

# Run with bash interpreter
bash script.sh

# Run with sh interpreter
sh script.sh

# Run from any directory (if in PATH)
script.sh
```

## Useful Commands for Shell Scripting

| Command | Description | Example |
|---------|-------------|---------|
| `ls` | List files | `ls -la` |
| `mkdir` | Create directory | `mkdir mydir` |
| `rm` | Remove files/directories | `rm -rf mydir` |
| `grep` | Search text | `grep "pattern" file.txt` |
| `awk` | Text processing | `awk '{print $1}' file.txt` |
| `sed` | Stream editor | `sed 's/old/new/g' file.txt` |
| `cut` | Extract columns | `cut -d',' -f1 file.csv` |
| `sort` | Sort lines | `sort file.txt` |
| `uniq` | Remove duplicates | `sort file.txt \| uniq` |

## Debugging Scripts

### Enable Debug Mode
```bash
# Run script in debug mode
bash -x script.sh

# Or add to script
set -x  # Enable debugging
set +x  # Disable debugging
```

### Common Debugging Techniques
```bash
# Print variables for debugging
echo "DEBUG: variable value is '$variable'" >&2

# Check exit codes
command
if [ $? -ne 0 ]; then
    echo "Command failed"
fi
```

This guide covers the fundamental concepts of shell scripting. Practice with the provided examples and gradually build more complex scripts as you become comfortable with these basics.****
