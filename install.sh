#!/bin/bash

# Update Termux packages
pkg update -y && pkg upgrade -y

# Install figlet
pkg install figlet -y

# Install injector
curl -o draco_injector.sh https://raw.githubusercontent.com/Sparklight77/Auto-Draco-Injector/main/draco_injector.sh

# Remove the script itself
rm -- "$0"

#message
echo"execute  draco_injector.sh  to Start injector"
