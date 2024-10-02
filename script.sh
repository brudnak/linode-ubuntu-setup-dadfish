#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package lists
apt update

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install GCC if not present
if ! command_exists gcc; then
    echo "GCC not found. Installing GCC..."
    apt install -y gcc
else
    echo "GCC is already installed."
fi

# Check and install Make if not present
if ! command_exists make; then
    echo "Make not found. Installing Make..."
    apt install -y make
else
    echo "Make is already installed."
fi

# Ensure snap is installed
if ! command_exists snap; then
    echo "Snap not found. Installing Snap..."
    apt install -y snapd
else
    echo "Snap is already installed."
fi

# Ensure the snap binary is in PATH for this script
export PATH=$PATH:/snap/bin

# Install Go using snap
if ! command_exists go; then
    echo "Go not found. Installing Go..."
    snap install go --classic
else
    echo "Go is already installed. Updating to the latest version..."
    snap refresh go
fi

# Update PATH to include Go binaries
echo 'export PATH=$PATH:/snap/bin:/root/go/bin' >> /etc/profile
source /etc/profile

# Verify installations
echo "GCC version:"
gcc --version

echo "Make version:"
make --version

echo "Go version:"
go version

# Additional Go installation verification
if command -v go &>/dev/null; then
    echo "Go is successfully installed and accessible."
else
    echo "Error: Go installation failed or Go is not in PATH."
    exit 1
fi

echo "Installation and verification complete!"
