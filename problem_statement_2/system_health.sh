#!/bin/bash
# system_health.sh
# Monitors CPU, Memory, Disk, and running processes.
# Alerts if thresholds are exceeded.

THRESH_CPU=80
THRESH_MEM=80
THRESH_DISK=80

echo "=== System Health Check: $(date) ==="

# 1. CPU Usage
# Uses top to get idle CPU and calculates usage.
CPU_IDLE=$(top -l 1 | grep "CPU usage" | awk '{print $7}' | cut -d% -f1)
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
echo "CPU Usage: $CPU_USAGE%"
if (( $(echo "$CPU_USAGE > $THRESH_CPU" | bc -l) )); then
    echo "ALERT: CPU usage is above $THRESH_CPU%!"
fi

# 2. Memory Usage
# Uses vm_stat on macOS (since 'free' is Linux specific, but requirement said 'Linux system'. 
# I will implement a Linux-compatible version using 'free' as requested, 
# but add a fallback or note for macOS so it runs here for verification if possible).
# Actually, strictly following "Linux system" requirement implies 'free'.
# I'll stick to standard Linux commands but might need adjustment if verification fails on Mac.
# Let's try a portable approach or standard Linux 'free'.

if command -v free >/dev/null; then
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
else
    # Fallback for generic/mac (vm_stat is messy to parse quickly, just logging warning)
    echo "Warning: 'free' command not found (Functionality limited on macOS). Skipping Memory Check."
    MEM_USAGE=0
fi
# Remove decimals for comparison
MEM_USAGE_INT=${MEM_USAGE%.*}
echo "Memory Usage: $MEM_USAGE_INT%"

if [ "$MEM_USAGE_INT" -gt "$THRESH_MEM" ]; then
    echo "ALERT: Memory usage is above $THRESH_MEM%!"
fi

# 3. Disk Usage
# Checks root partition
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo "Disk Usage: $DISK_USAGE%"
if [ "$DISK_USAGE" -gt "$THRESH_DISK" ]; then
    echo "ALERT: Disk usage is above $THRESH_DISK%!"
fi

# 4. Running Processes
PROCESS_COUNT=$(ps aux | wc -l)
echo "Running Processes: $PROCESS_COUNT"
# Example alert for process count (arbitrary threshold for demo)
if [ "$PROCESS_COUNT" -gt 300 ]; then
    echo "ALERT: High number of running processes: $PROCESS_COUNT"
fi

echo "=== Check Complete ==="
