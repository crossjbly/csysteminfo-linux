#!/bin/bash

# Define the URL to download the system info script
SCRIPT_URL="https://raw.githubusercontent.com/crossjbly/csysteminfo-linux/refs/heads/main/csysteminfo.sh"

# Define the destination directory for installation
INSTALL_DIR="$HOME/.local/bin"

# Define the system info script filename
SCRIPT_NAME="csysteminfo.sh"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Check if the installation directory exists, create it if not
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Download the system info script from the URL
echo "Downloading system info script from $SCRIPT_URL..."
curl -s -o "$SCRIPT_PATH" "$SCRIPT_URL"

# Check if the download was successful
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Failed to download the system info script from $SCRIPT_URL"
    exit 1
fi

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Create a symbolic link to the script in $HOME/.local/bin
if [ ! -L "$INSTALL_DIR/csysteminfo" ]; then
    echo "Creating symlink for csysteminfo command"
    ln -s "$SCRIPT_PATH" "$INSTALL_DIR/csysteminfo"
fi

# Inform the user
echo "Installation complete! You can now run the system info script with the command 'csysteminfo'."
