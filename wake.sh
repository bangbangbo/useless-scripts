#!/bin/bash

# morning setup automation
# opens applications, terminals, and browser tabs

echo "status: initializing morning setup"

# system info
echo "date: $(date)"
echo "uptime: $(uptime -p)"
echo "disk: $(df -h / | awk 'NR==2{print $5}')"

# open applications
if command -v code &> /dev/null; then
    code ~/projects &
fi

if command -v brave-browser &> /dev/null; then
    brave-browser "file:///usr/share/homepage/index.html" "https://github.com/vemacitrind" "https://leetcode.com/problemset" &
elif command -v google-chrome &> /dev/null; then
    google-chrome "https://github.com" "https://stackoverflow.com" "https://gmail.com" &
fi

# open terminals
if [ -d ~/projects ]; then
    gnome-terminal --working-directory=~/projects &
fi

if [ -d ~/Documents ]; then
    gnome-terminal --working-directory=~/Documents &
fi

echo "status: setup complete"