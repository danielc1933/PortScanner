Overview

A very basic port scanner built for personal scanning. This script helps you identify open ports on a target host. If you're looking for a more advanced scanner, consider using Nmap.

Features

Scans for open TCP and UDP ports.

Supports service detection and banner grabbing.

Customizable port ranges and scan types.

Lightweight and easy to use.

Usage

Installation

Clone the repository:

git clone https://github.com/yourusername/port-scanner.git
cd port-scanner

Make the script executable:

chmod +x port_scanner.sh

Running the Script

Basic Scan:

./port_scanner.sh <host>

Example:

./port_scanner.sh scanme.nmap.org

Custom Port Range:

./port_scanner.sh <host> <start_port> <end_port>

Example:

./port_scanner.sh 192.168.1.1 1 1000

Different Scan Types:

./port_scanner.sh <host> <start_port> <end_port> <scan_type>

Scan Types:

tcp (default) - Basic TCP scan

udp - UDP port scan

service - Detect running services

banner - Grab service banners

Example:

./port_scanner.sh example.com 80 443 banner

Disclaimer

This script is for educational and personal use only. Do not use it to scan networks without permission.

Want More Features?

Check out Nmap for a more comprehensive scanning tool!

License

This project is licensed under the MIT License.

Enjoy scanning responsibly! 🚀
