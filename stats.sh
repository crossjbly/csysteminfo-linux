#!/bin/bash

# Define color codes for easy reading
RESET="\e[0m"
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"

# Function to collect system information
collect_system_info() {
    # Collect OS Information
    OS_INFO="Operating System: $(uname -s)\n"
    OS_INFO+="OS Version: $(uname -r)\n"
    OS_INFO+="OS Details: $(lsb_release -a 2>/dev/null || echo 'Not Available')\n"

    # Collect Kernel and Architecture
    KERNEL_INFO="Kernel Version: $(uname -v)\n"
    KERNEL_INFO+="Machine Architecture: $(uname -m)\n"

    # Collect Hardware Information
    CPU_INFO="CPU Model: $(lscpu | grep 'Model name' | awk -F ':' '{print $2}' | xargs)\n"
    CPU_INFO+="CPU Cores: $(nproc)\n"
    RAM_INFO="Memory (RAM): $(free -h | grep Mem | awk '{print $2}')\n"
    SWAP_INFO="Swap: $(free -h | grep Swap | awk '{print $2}')\n"

    # Collect Disk Usage
    DISK_INFO="Disk Usage: $(df -h --total | grep total | awk '{print $3 " / " $2 " (" $5 ")"}')\n"

    # Collect Network Information (Check if hostname exists)
    if command -v hostname >/dev/null 2>&1; then
        NETWORK_INFO="Hostname: $(hostname)\n"
        NETWORK_INFO+="IP Address: $(hostname -I)\n"
        NETWORK_INFO+="Network Interfaces: $(ip a | grep -oP '^\d+:\s*\K[^\:]*')\n"
    else
        NETWORK_INFO="Network Information: Not available\n"
    fi

    # Collect System Load and Uptime
    LOAD_INFO="Uptime: $(uptime -p)\n"
    LOAD_INFO+="System Load (1, 5, 15 min): $(uptime | awk -F'load average:' '{ print $2 }' | xargs)\n"

    # Collect File System Info
    FILESYSTEM_INFO="Mounted Filesystems:\n"
    FILESYSTEM_INFO+=$(df -hT | awk 'NR>1 {print $1, $2, $3, $6}' | while read -r line; do
        echo -e "${BOLD}${MAGENTA}$line${RESET}"
    done)

    # Battery Information (if applicable)
    if command -v upower >/dev/null 2>&1; then
        BATTERY_INFO="Battery Status: $(upower -i /org/freedeskop/UPower/devices/battery_BAT0 | grep -E 'state|percentage')\n"
    else
        BATTERY_INFO="Battery Information: Not available\n"
    fi

    # Collect System Processes
    PROCESS_INFO="Top 5 Processes by CPU usage:\n"
    PROCESS_INFO+=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | while read -r line; do
        echo -e "${BOLD}${RED}$line${RESET}"
    done)
}

# Function to display collected system information
display_system_info() {
    echo -e "${BOLD}${CYAN}---- System Information ----${RESET}"

    # Display collected system info
    echo -e "${BOLD}${GREEN}$OS_INFO${RESET}"
    echo -e "${BOLD}${GREEN}$KERNEL_INFO${RESET}"
    echo -e "${BOLD}${YELLOW}$CPU_INFO${RESET}"
    echo -e "${BOLD}${YELLOW}$RAM_INFO${RESET}"
    echo -e "${BOLD}${YELLOW}$SWAP_INFO${RESET}"
    echo -e "${BOLD}${MAGENTA}$DISK_INFO${RESET}"
    echo -e "${BOLD}${BLUE}$NETWORK_INFO${RESET}"
    echo -e "${BOLD}${CYAN}$LOAD_INFO${RESET}"
    echo -e "${BOLD}${MAGENTA}$FILESYSTEM_INFO${RESET}"
    echo -e "${BOLD}${YELLOW}$BATTERY_INFO${RESET}"
    echo -e "${BOLD}${RED}$PROCESS_INFO${RESET}"

    # Exit after displaying the info
    exit 0
}

# Initial collection of system information
collect_system_info

# Display the system info once
display_system_info
