#!/bin/bash

# Prompt the user for input
echo "Enter the username to filter for (e.g., root):"
read username

if [ -z "$username" ]; then
  echo "No username word provided. Exiting."
  exit 1
fi

echo "<group>,<username>"

cat /etc/group | awk -F ':' '{print $1 "," $NF}' | awk -v username="$username" -F ',' 'NF >= 2 && $2 == username'