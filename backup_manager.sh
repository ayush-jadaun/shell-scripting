#!/bin/bash

echo "=== Backup Manager Script ==="

BACKUP_ROOT="backups"
DATE=$(date +%Y%m%d_%H%M%S)
CONFIG_FILE="backup_config.conf"

# Create configuration file
create_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" << EOF
# Backup Configuration
# Directories to backup (one per line)
./test_dir
./documents
./scripts

# Files to exclude (patterns)
*.tmp
*.log
.git/
EOF
        echo "Created configuration file: $CONFIG_FILE"
    fi
}

# Create test directories and files
setup_test_environment() {
    mkdir -p test_dir/subdir documents scripts
    echo "Test file 1" > test_dir/file1.txt
    echo "Test file 2" > test_dir/file2.txt
    echo "Temp file" > test_dir/temp.tmp
    echo "Log file" > test_dir/app.log
    echo "Document 1" > documents/doc1.txt
    echo "Script 1" > scripts/script1.sh
    echo "Test environment created"
}

# Read directories from config
read_backup_dirs() {
    local dirs=()
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        # Stop at exclude patterns section
        [[ "$line" == "*.tmp" ]] && break
        dirs+=("$line")
    done < "$CONFIG_FILE"
    echo "${dirs[@]}"
}

# Read exclude patterns from config
read_exclude_patterns() {
    local patterns=()
    local in_exclude_section=false
    while IFS= read -r line; do
        # Start reading after we find exclude patterns
        [[ "$line" == "*.tmp" ]] && in_exclude_section=true
        if $in_exclude_section; then
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
            patterns+=("$line")
        fi
    done < "$CONFIG_FILE"
    echo "${patterns[@]}"
}

# Perform backup
perform_backup() {
    local backup_name="backup_$DATE"
    local backup_path="$BACKUP_ROOT/$backup_name"
    
    echo "Starting backup: $backup_name"
    mkdir -p "$backup_path"
    
    # Read configuration
    local dirs=($(read_backup_dirs))
    local exclude_patterns=($(read_exclude_patterns))
    
    # Build exclude options for tar
    local exclude_opts=""
    for pattern in "${exclude_patterns[@]}"; do
        exclude_opts="$exclude_opts --exclude=$pattern"
    done
    
    # Create backup
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "Backing up: $dir"
            tar czf "$backup_path/$(basename "$dir").tar.gz" $exclude_opts "$dir" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "✓ Successfully backed up $dir"
            else
                echo "✗ Failed to backup $dir"
            fi
        else
            echo "⚠ Directory not found: $dir"
        fi
    done
    
    # Create backup info file
    {
        echo "Backup Information"
        echo "=================="
        echo "Date: $(date)"
        echo "Backup Name: $backup_name"
        echo "Directories:"
        printf '%s\n' "${dirs[@]}"
        echo ""
        echo "Exclude Patterns:"
        printf '%s\n' "${exclude_patterns[@]}"
    } > "$backup_path/backup_info.txt"
    
    echo "Backup completed: $backup_path"
}

# List existing backups
list_backups() {
    echo -e "\n=== Existing Backups ==="
    if [ -d "$BACKUP_ROOT" ]; then
        ls -la "$BACKUP_ROOT" | grep "backup_" | while read -r line; do
            backup_name=$(echo "$line" | awk '{print $NF}')
            backup_date=$(echo "$backup_name" | sed 's/backup_//' | sed 's/_/ /')
            echo "$backup_name (Created: $backup_date)"
        done
    else
        echo "No backups found"
    fi
}

# Restore backup
restore_backup() {
    list_backups
    echo ""
    read -p "Enter backup name to restore (or 'cancel'): " backup_name
    
    if [ "$backup_name" = "cancel" ]; then
        echo "Restore cancelled"
        return
    fi
    
    local backup_path="$BACKUP_ROOT/$backup_name"
    if [ ! -d "$backup_path" ]; then
        echo "Backup not found: $backup_name"
        return 1
    fi
    
    local restore_dir="restored_$DATE"
    mkdir -p "$restore_dir"
    
    echo "Restoring backup to: $restore_dir"
    for archive in "$backup_path"/*.tar.gz; do
        if [ -f "$archive" ]; then
            echo "Extracting: $(basename "$archive")"
            tar xzf "$archive" -C "$restore_dir"
        fi
    done
    
    echo "Restore completed to: $restore_dir"
}

# Clean old backups
clean_old_backups() {
    read -p "Keep how many recent backups? (default: 5): " keep_count
    keep_count=${keep_count:-5}
    
    if [ -d "$BACKUP_ROOT" ]; then
        local backup_count=$(ls -1 "$BACKUP_ROOT" | grep "backup_" | wc -l)
        if [ "$backup_count" -gt "$keep_count" ]; then
            echo "Removing old backups..."
            ls -1t "$BACKUP_ROOT" | grep "backup_" | tail -n +$((keep_count + 1)) | while read -r old_backup; do
                echo "Removing: $old_backup"
                rm -rf "$BACKUP_ROOT/$old_backup"
            done
        else
            echo "No old backups to remove (found $backup_count, keeping $keep_count)"
        fi
    fi
}

# Main menu
main_menu() {
    echo -e "\n=== Backup Manager Menu ==="
    echo "1. Perform backup"
    echo "2. List backups"
    echo "3. Restore backup"
    echo "4. Clean old backups"
    echo "5. Exit"
    read -p "Enter choice [1-5]: " choice
    
    case $choice in
        1) perform_backup ;;
        2) list_backups ;;
        3) restore_backup ;;
        4) clean_old_backups ;;
        5) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
}

# Initialize
create_config
setup_test_environment

# Run main menu
while true; do
    main_menu
    echo -e "\nPress Enter to continue..."
    read
done
