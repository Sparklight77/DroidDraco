#!/bin/bash
echo -e "\033[1;33m Setting up Injector.......\033[0m"
# Setup storage permission
directory="storage"
if [ -d "$directory" ]; then
    echo -e "Termux already have storage permission. Skipping...\n"
else
    termux-setup-storage
fi

# Prompt the user to select the architecture for injection process 
echo "Select the architecture: "
echo "1) aarch64"
echo "2) armv7l"

read -p "Select desired architecture: "  arch

# Set variables based on the user's choice
case "$arch" in
    1)
        arch="aarch64"
        injector_link="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.4/injector-aarch64-linux-android.tar.gz"
        injector_file="injector-aarch64-linux-android.tar.gz"
        ;;
    2)
        arch="armv7l"
        injector_link="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.4/injector-armv7-linux-androideabi.tar.gz"
        injector_file="injector-armv7-linux-androideabi.tar.gz"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac


# find minecraft in storage. Thanks callmesoumya
files=()
while IFS= read -r filename; do
  files+=("$filename")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#files[@]} -eq 0 ]; then
    echo "No Minecraft named APK files found."
elif [ ${#files[@]} -eq 1 ]; then
    selected_file="${files[0]}"
    echo "Found one APK: $selected_file"
else
    echo "Multiple APK files found:"
    select selected_file in "${files[@]}"; do
        if [ -n "$selected_file" ]; then
            echo "Selected APK file: $selected_file"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
fi


# Patch information 
echo "Enter info to start patch injection process......."
read -p "App Name (shows in launcher): " APP
read -p "Package Name (enter valid order): " PACKAGE
read -p "Output APK Name (include .apk): " OUTPUT


# download injector based on presence in storage 
if [ -f "$injector_file" ]; then
    echo -e "\033[0;32m Injector already exists, skipping download process....\033[0m"
else
    echo "Downloading injector for '$arch...'"
    curl -L -o "$injector_file" "$injector_link"
fi
# Injector Extraction
echo -e "\033[0m Extracting injector for $arch....\033[0m"
       tar xvzf "$injector_file"


# Run injector
if ./injector "$selected_file" -a "$APP" -p "$PACKGE" -o "$OUTPUT"; then
    echo -e "Injection successfully completed\n"
    else
     echo "injection process failed"
     exit 1
fi


# Define the directory path
DIR="/storage/emulated/0/MCPatch"
# Check if the directory exists
if [ ! -d "$DIR" ]; then
  # If the directory does not exist, create it
  mkdir -p "$DIR"
  echo -e "\033[1;33m Directory 'MCPatch' successfully created. Moving files....\033[0m"
else
# If the directory exists, print a message
  echo -e "\033[1;33mDirectory 'MCPatch' already exists. Moving files...\033[0m"
fi

# move output to patch folder
mv "$OUTPUT" /storage/emulated/0/MCPatch
echo -e "\033[0;32mProcess successfully completed.\033[0m"
exit 0