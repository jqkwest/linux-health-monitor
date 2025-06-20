#!/bin/bash
# linux-health-monitor.sh
# Comprehensive system monitoring script

echo "=== System Health Monitor ==="
echo "Generated on: $(date)"
echo

# System Information
echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo

# Resource Usage
echo "=== Resource Usage ==="
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
echo
echo "Memory Usage:"
free -h
echo
echo "Disk Usage:"
df -h | grep -vE '^Filesystem|tmpfs|cdrom'
echo

# Network Information
echo "=== Network Information ==="
echo "Active Connections:"
ss -tuln | wc -l
echo
echo "Network Interfaces:"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
echo

# Service Status
echo "=== Critical Services ==="
services=("ssh" "nginx" "docker")
for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "$service: ✓ Running"
    else
        echo "$service: ✗ Not Running"
    fi
done
echo

# Security Check
echo "=== Security Status ==="
echo "Failed Login Attempts (last 24h):"
journalctl --since "24 hours ago" | grep "Failed password" | wc -l
echo
echo "Firewall Status:"
ufw status | head -1
