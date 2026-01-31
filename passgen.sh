#!/bin/bash

# secure password generator
# generates random passwords with customizable length

LENGTH=${1:-16}

if ! [[ "$LENGTH" =~ ^[0-9]+$ ]] || [ "$LENGTH" -lt 4 ]; then
    echo "usage: $0 [length]"
    echo "length must be >= 4 (default: 16)"
    exit 1
fi

# generate password using /dev/urandom
PASSWORD=$(tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' < /dev/urandom | head -c "$LENGTH")

echo "password: $PASSWORD"

# copy to clipboard if available
if command -v xclip &> /dev/null; then
    echo -n "$PASSWORD" | xclip -selection clipboard
    echo "status: copied to clipboard"
elif command -v pbcopy &> /dev/null; then
    echo -n "$PASSWORD" | pbcopy
    echo "status: copied to clipboard"
fi