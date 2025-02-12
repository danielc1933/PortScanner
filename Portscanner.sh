#!/bin/bash

# ASCII Art Intro
echo -e "\033[1;34m
  ____            _       ____                  
 |  _ \ ___  _ __| |_ ___/ ___|  ___ __ _ _ __  
 | |_) / _ \| '__| __/ __\___ \ / __/ _\` | '_ \ 
 |  __/ (_) | |  | |_\__ \___) | (_| (_| | | | |
 |_|   \___/|_|   \__|___/____/ \___\__,_|_| |_|
                                                
\033[0m"
echo -e "\033[1;36mSimple Port Scanner by CatsNcats\033[0m"
echo -e "\033[1;36m------------------------------------------\033[0m"
echo -e "\033[1;33mUsage: $0 <host> [start_port] [end_port] [scan_type]\033[0m"
echo -e "\033[1;33mScan types: tcp (default), udp, service, banner\033[0m"
echo -e "\033[1;36m------------------------------------------\033[0m"

# Function to display help
display_help() {
    echo -e "\033[1;33mUsage: $0 <host> [start_port] [end_port] [scan_type]\033[0m"
    echo -e "\033[1;33mExample: $0 example.com\033[0m"
    echo -e "\033[1;33mExample: $0 192.168.1.1 1 100 tcp\033[0m"
    echo -e "\033[1;33mExample: $0 example.com 80 443 banner\033[0m"
    exit 0
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
fi

# Validate arguments
if [ -z "$1" ]; then
    echo -e "\033[1;31mError: Host argument is required.\033[0m"
    display_help
    exit 1
fi

host=$1
start_port=${2:-1}          # Default start port: 1
end_port=${3:-1024}         # Default end port: 1024 (common ports)
scan_type=${4:-tcp}         # Default scan type: tcp

# Validate port range
if [[ $start_port -lt 1 || $start_port -gt 65535 || $end_port -lt 1 || $end_port -gt 65535 ]]; then
    echo -e "\033[1;31mError: Ports must be between 1 and 65535.\033[0m"
    exit 1
fi

# Function to check if host is reachable
check_host() {
    echo -e "\033[1;32mChecking if host $host is reachable...\033[0m"
    # Try connecting to port 80 (HTTP) or port 443 (HTTPS)
    (echo >/dev/tcp/$host/80) >/dev/null 2>&1 || (echo >/dev/tcp/$host/443) >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "\033[1;31mHost $host is unreachable or does not respond to common ports (80/443).\033[0m"
        exit 1
    else
        echo -e "\033[1;32mHost $host is reachable.\033[0m"
    fi
}

# Function to perform TCP scan
tcp_scan() {
    echo -e "\033[1;32mScanning $host (TCP) from port $start_port to $end_port...\033[0m"
    for ((port=start_port; port<=end_port; port++))
    do
        (echo >/dev/tcp/$host/$port) >/dev/null 2>&1 && echo -e "\033[1;32mPort $port is open\033[0m" || echo -e "\033[1;31mPort $port is closed\033[0m"
    done
}

# Function to perform UDP scan
udp_scan() {
    echo -e "\033[1;32mScanning $host (UDP) from port $start_port to $end_port...\033[0m"
    for ((port=start_port; port<=end_port; port++))
    do
        (echo >/dev/udp/$host/$port) >/dev/null 2>&1 && echo -e "\033[1;32mPort $port is open\033[0m" || echo -e "\033[1;31mPort $port is closed\033[0m"
    done
}

# Function to perform service detection
service_detection() {
    echo -e "\033[1;32mScanning $host (TCP) with service detection from port $start_port to $end_port...\033[0m"
    for ((port=start_port; port<=end_port; port++))
    do
        (echo >/dev/tcp/$host/$port) >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            service=$(grep $port /etc/services | awk '{print $1}')
            echo -e "\033[1;32mPort $port is open - Service: ${service:-unknown}\033[0m"
        else
            echo -e "\033[1;31mPort $port is closed\033[0m"
        fi
    done
}

# Function to perform banner grabbing
banner_grabbing() {
    echo -e "\033[1;32mScanning $host (TCP) with banner grabbing from port $start_port to $end_port...\033[0m"
    for ((port=start_port; port<=end_port; port++))
    do
        (echo >/dev/tcp/$host/$port) >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            banner=$(timeout 2 bash -c "exec 3<>/dev/tcp/$host/$port; cat <&3" 2>/dev/null)
            echo -e "\033[1;32mPort $port is open - Banner: $banner\033[0m"
        else
            echo -e "\033[1;31mPort $port is closed\033[0m"
        fi
    done
}

# Main logic
check_host
case $scan_type in
    tcp)
        tcp_scan
        ;;
    udp)
        udp_scan
        ;;
    service)
        service_detection
        ;;
    banner)
        banner_grabbing
        ;;
    *)
        echo -e "\033[1;31mInvalid scan type. Available types: tcp, udp, service, banner\033[0m"
        exit 1
        ;;
esac