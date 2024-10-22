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

# Install Go
if ! command_exists go; then
    echo "Go not found. Installing Go..."

    # Get latest Go version
    GO_LATEST_VERSION=$(curl -s https://go.dev/VERSION\?m\=text | head -1)
    GO_ZIP_FILE=${GO_LATEST_VERSION}.linux-amd64.tar.gz

    # Download Go
    wget https://go.dev/dl/${GO_ZIP_FILE}
    sudo tar -C /usr/local -xvzf ${GO_ZIP_FILE}

    # Create Sym Link for Go bin
    sudo ln -sf /usr/local/go/bin/go /usr/bin/go

    # Remove Go zip file
    rm $GO_ZIP_FILE

else
    echo "Go is already installed. Updating to the latest version..."
fi

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
