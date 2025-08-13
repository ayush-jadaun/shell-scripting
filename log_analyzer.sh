echo "=== Log Analyzer Script ==="

LOG_FILE="sample.log"

# Create sample log file if it doesn't exist
create_sample_log() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "Creating sample log file..."
        cat > "$LOG_FILE" << EOF
2024-01-15 10:30:15 [INFO] Application started successfully
2024-01-15 10:30:16 [INFO] Database connection established
2024-01-15 10:31:22 [WARNING] High memory usage detected: 85%
2024-01-15 10:32:45 [ERROR] Failed to process request: timeout
2024-01-15 10:33:12 [INFO] User john logged in from 192.168.1.100
2024-01-15 10:34:33 [ERROR] Database query failed: connection lost
2024-01-15 10:35:21 [INFO] User jane logged in from 192.168.1.101
2024-01-15 10:36:44 [WARNING] Disk usage above 90%
2024-01-15 10:37:15 [INFO] Backup process completed
2024-01-15 10:38:22 [ERROR] Authentication failed for user admin
2024-01-15 10:39:33 [INFO] System maintenance scheduled
2024-01-15 10:40:45 [WARNING] SSL certificate expires in 30 days
EOF
        echo "Sample log file created: $LOG_FILE"
    fi
}

# Analyze log levels
analyze_log_levels() {
    echo -e "\n=== Log Level Analysis ==="
    echo "INFO messages: $(grep -c '\[INFO\]' "$LOG_FILE")"
    echo "WARNING messages: $(grep -c '\[WARNING\]' "$LOG_FILE")"
    echo "ERROR messages: $(grep -c '\[ERROR\]' "$LOG_FILE")"
    echo "Total log entries: $(wc -l < "$LOG_FILE")"
}

# Show recent errors
show_recent_errors() {
    echo -e "\n=== Recent Errors ==="
    grep '\[ERROR\]' "$LOG_FILE" | tail -5
}

# Extract IP addresses
extract_ips() {
    echo -e "\n=== IP Addresses Found ==="
    grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$LOG_FILE" | sort | uniq -c | sort -rn
}

# Search for specific pattern
search_logs() {
    read -p "Enter search pattern: " pattern
    echo -e "\n=== Search Results for '$pattern' ==="
    grep -i "$pattern" "$LOG_FILE" || echo "No matches found"
}

# Generate log summary report
generate_report() {
    local report_file="log_report_$(date +%Y%m%d_%H%M%S).txt"
    echo "Generating log report: $report_file"
    
    {
        echo "LOG ANALYSIS REPORT"
        echo "Generated on: $(date)"
        echo "Log file: $LOG_FILE"
        echo "=================================="
        
        analyze_log_levels
        echo ""
        
        echo "=== RECENT ERRORS ==="
        show_recent_errors
        echo ""
        
        echo "=== IP ADDRESSES ==="
        extract_ips
        
    } > "$report_file"
    
    echo "Report saved to: $report_file"
}

# Main execution
create_sample_log
analyze_log_levels
show_recent_errors
extract_ips

echo -e "\n=== Additional Options ==="
echo "1. Search logs"
echo "2. Generate report"
read -p "Choose option (1/2) or press Enter to skip: " option

case $option in
    1) search_logs ;;
    2) generate_report ;;
esac

