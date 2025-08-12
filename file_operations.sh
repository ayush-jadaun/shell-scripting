echo "=== File Operations Script ==="

BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
TEST_FILE="test_file.txt"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"

# Create test file with content
cat > "$TEST_FILE" << EOF
This is a test file
Line 2: $(date)
Line 3: Current user is $USER
Line 4: Working directory is $(pwd)
EOF

echo "Created test file: $TEST_FILE"

# File information
echo -e "\nFile information for $TEST_FILE:"
echo "Size: $(wc -c < "$TEST_FILE") bytes"
echo "Lines: $(wc -l < "$TEST_FILE")"
echo "Words: $(wc -w < "$TEST_FILE")"
echo "Permissions: $(ls -l "$TEST_FILE" | cut -d' ' -f1)"

# Copy file to backup
cp "$TEST_FILE" "$BACKUP_DIR/"
echo "Copied $TEST_FILE to $BACKUP_DIR/"

# Search in file
echo -e "\nSearching for 'user' in $TEST_FILE:"
grep -n "user" "$TEST_FILE" || echo "Pattern not found"

# Clean up function
cleanup() {
    echo -e "\nCleaning up..."
    rm -rf "$BACKUP_DIR" "$TEST_FILE"
    echo "Cleanup completed"
}

# Ask user if they want to keep files
read -p "Keep created files? (y/n): " keep_files
if [[ $keep_files != "y" ]]; then
    cleanup
fi
