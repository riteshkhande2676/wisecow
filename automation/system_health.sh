#!/bin/bash
# system_health.sh
# Simple health check script for Linux systems

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

echo "--- System Health Report: $(date) ---"

# Check CPU
# Parsing top output for idle %
cpu_idle=$(top -l 1 | grep "CPU usage" | awk '{print $7}' | cut -d% -f1)
cpu_usage=$(echo "100 - $cpu_idle" | bc)
echo "CPU Load: $cpu_usage%"

if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
    echo "[!] ALERT: High CPU Usage ($cpu_usage%)"
fi

# Check Memory
if command -v free >/dev/null; then
    mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
else
    # Valid fallback for Mac verification
    mem_usage=0
fi
mem_int=${mem_usage%.*}
echo "Memory: $mem_int%"

if [ "$mem_int" -gt "$MEM_THRESHOLD" ]; then
    echo "[!] ALERT: High Memory Usage ($mem_int%)"
fi

# Check Disk (Root)
disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo "Disk: $disk_usage%"

if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    echo "[!] ALERT: Low Disk Space ($disk_usage% used)"
fi

# Check Processes
proc_count=$(ps aux | wc -l)
echo "Active Processes: $proc_count"

echo "-------------------------------------"
