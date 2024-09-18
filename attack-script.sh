#!/bin/bash

# Define the subnets to scan (you can add more subnets as needed)
subnets=("192.168.1.0/24" "192.168.2.0/24")

# Temporary file to store discovered IP addresses
temp_file=$(mktemp)

# Scan each subnet with netdiscover
for subnet in "${subnets[@]}"; do
    echo "Scanning subnet: $subnet"
    sudo netdiscover -r $subnet -P -N | grep -oP '(\d{1,3}\.){3}\d{1,3}' >> "$temp_file"
done

# Remove duplicate IPs
sort -u "$temp_file" -o "$temp_file"

# Run nmap on each discovered IP address
while read -r ip; do
    echo "Running nmap on $ip"
    nmap "$ip"
done < "$temp_file"

# Clean up
rm "$temp_file"

echo "Scan completed."
