#!/bin/bash
# Clear terminal
clear
# Fancy text
figlet -f big "DRACO"

# Define color variables
RESET='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Decorative fancy text
echo -e "${YELLOW} Initializing Injector Setup... ${RESET}"
sleep 1

# Check storage permissions
storage_dir="storage"
if [ -d "$storage_dir" ]; then
    echo -e " ${CYAN} Storage permission already granted to Termux. Proceeding... ${RESET}\n"
else
    echo -e " ${YELLOW} Granting storage permissions, press allow to proceed... ${RESET}"
    termux-setup-storage
fi

# Function to auto-detect architecture
auto_detect() {
    detected_arch=$(uname -m)
    case "$detected_arch" in
        aarch64)
            arch="aarch64"
            injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.7/injector-aarch64-linux-android.tar.gz"
            injector_filename="injector-aarch64-linux-android.tar.gz"
            ;;
        armv7l)
            arch="armv7l"
            injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.7/injector-armv7-linux-androideabi.tar.gz"
            injector_filename="injector-armv7-linux-androideabi.tar.gz"
            ;;
        x86_64)
            arch="x86_64"
            injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.7/injector-x86_64-unknown-linux-gnu.tar.gz"
            injector_filename="injector-x86_64-unknown-linux-gnu.tar.gz"
            ;;
        *)
            echo -e "${RED} Unsupported architecture detected: $detected_arch. Exiting... ${RESET}"
            exit 1
            ;;
    esac
}

# Prompt user to choose the architecture
echo -e "${BOLD_RED}Please choose the architecture:${RESET}"
echo -e "${BOLD_RED}1) aarch64${RESET}"
echo -e "${BOLD_RED}2) armv7l${RESET}"
echo -e "${BOLD_RED}3) x86_64${RESET}"
echo -e "${BOLD_RED}4) Auto-detect${RESET}"
read -p "$(echo -e ${BOLD_RED}Enter the number corresponding to the desired architecture:${RESET} ) " arch

# Set variables according to the user's selection
case "$arch" in
    1)
        arch="aarch64"
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.7/injector-aarch64-linux-android.tar.gz"
        injector_filename="injector-aarch64-linux-android.tar.gz"
        ;;
    2)
        arch="armv7l"
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.7/injector-armv7-linux-androideabi.tar.gz"
        injector_filename="injector-armv7-linux-androideabi.tar.gz"
        ;;
    3)
        arch="x86_64"
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.7/injector-x86_64-unknown-linux-gnu.tar.gz"
        injector_filename="injector-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    4)
        auto_detect
        ;;
    *)
        echo -e "${RED} Invalid selection. Exiting... ${RESET}"
        exit 1
        ;;
esac

# Search for Minecraft APK files in the storage. Thanks to @callmesoumya 
apk_files=()
while IFS= read -r apk_file; do
  apk_files+=("$apk_file")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#apk_files[@]} -eq 0 ]; then
    echo -e "${RED}No APK files containing 'minecraft' in their names were found.${RESET}"
elif [ ${#apk_files[@]} -eq 1 ]; then
    selected_apk="${apk_files[0]}"
    echo -e "${BLUE} One APK found: $selected_apk ${RESET}"
else
    echo "Multiple APK files found:"
    select selected_apk in "${apk_files[@]}"; do
        if [ -n "$selected_apk" ]; then
            echo -e "Selected APK file: $selected_apk"
            break
        else
            echo -e "${RED} Invalid choice. Please try again. ${RESET}"
        fi
    done
fi

# Prompt user for patch information
echo -e "${BOLD_RED}Provide the following details to initiate the patch injection process:${RESET}"
read -p "App Name (as it will appear in the launcher): " app_name
read -p "Package Name (use correct format): " package_name
read -p "Output APK Name (include .apk extension): " output_apk_name

# Download the injector if not already present
if [ -f "$injector_filename" ]; then
    echo -e "${YELLOW} Injector already downloaded. Skipping download... ${RESET}"
else
    echo -e "${YELLOW} Downloading the injector for '$arch'... ${RESET}"
    curl -L -o "$injector_filename" "$injector_url"
fi

# Extract the injector
echo -e "${BLUE} Extracting the injector for $arch...${RESET}"
tar xvzf "$injector_filename"

# Execute the injector
if ./injector "$selected_apk" -a "$app_name" -p "$package_name" -o "$output_apk_name"; then
    echo -e "${GREEN} Injection completed successfully${RESET}\n"
else
    echo -e "${RED} Injection process failed. ${RESET}"
    exit 1
fi

# Define the directory path for the patched APK
patch_dir="/storage/emulated/0/MCPatch"

# Create the directory if it doesn't exist
if [ ! -d "$patch_dir" ]; then
  mkdir -p "$patch_dir"
  echo -e "${BOLD_YELLOW} 'MCPatch' directory created successfully. Moving files...${RESET}"
  sleep 8
else
  echo -e "${BOLD_YELLOW} 'MCPatch' directory already exists. Moving files...${RESET}"
  sleep 5
fi

# Move the output APK to the MCPatch directory
mv "$output_apk_name" "$patch_dir"
echo -e "${GREEN} Injection Process completed successfully.${RESET}"
exit 0