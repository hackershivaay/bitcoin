#!/bin/bash

# This script installs Python, necessary dependencies, XMRig, and configures it to mine with both CPU and GPU (RandomX for Monero-like coins).

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Update system and upgrade installed packages
echo "Updating system and upgrading packages..."
sudo apt update && sudo apt upgrade -y || handle_error "Failed to update packages."

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip || handle_error "Failed to install Python 3 and pip."

# Install build tools and dependencies for XMRig and AMD GPU support
echo "Installing build-essential, curl, libssl-dev, libhwloc-dev, and AMD GPU dependencies..."
sudo apt install -y build-essential curl libssl-dev libhwloc-dev libclang-dev ocl-icd-opencl-dev || handle_error "Failed to install dependencies."

# Install ROCm (for AMD GPU support) - Required for OpenCL-based mining
echo "Installing ROCm for AMD GPU support..."
wget -qO - https://packages.amd.com/rocm/rocm.gpg.key | sudo apt-key add - || handle_error "Failed to add ROCm key."
echo "deb [arch=amd64] https://packages.amd.com/rocm/apt/rocm-4.0/ ubuntu main" | sudo tee /etc/apt/sources.list.d/rocm.list || handle_error "Failed to add ROCm repository."
sudo apt update || handle_error "Failed to update ROCm repository."
sudo apt install rocm-dkms -y || handle_error "Failed to install ROCm for AMD GPU."

# Check Python installation
echo "Verifying Python installation..."
python3 --version || handle_error "Python 3 installation failed."
pip3 --version || handle_error "Pip installation failed."

# Download the latest version of XMRig (RandomX mining)
echo "Downloading XMRig..."
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/xmrig/xmrig/releases/latest | jq -r .tarball_url)
curl -LO "$LATEST_RELEASE_URL" || handle_error "Failed to download XMRig."

# Extract XMRig
echo "Extracting XMRig..."
tar -xvzf xmrig-*.tar.gz || handle_error "Failed to extract XMRig."
cd xmrig-*/ || handle_error "Failed to enter the XMRig directory."

# Ensure XMRig binary is executable
chmod +x xmrig || handle_error "Failed to make XMRig executable."

# Set up basic XMRig config (User should edit later)
echo "Setting up basic XMRig configuration..."

# Your Bitcoin address (as provided)
wallet_address="1J2knNSBQHk1FQzxK2yHnZNTf7Gfk8gsmT"

# Create the config.json file with user input
cat <<EOL > config.json
{
    "pools": [
        {
            "url": "rx.unmineable.com:3333",  // Your chosen pool
            "user": "$wallet_address",  // Your Bitcoin address
            "pass": "x"
        }
    ],
    "cpu": {
        "enabled": true,  // Enable CPU mining
        "threads": 0  // 0 means auto-detect CPU threads
    },
    "opencl": {
        "enabled": true,  // Enable GPU mining (OpenCL for AMD GPUs)
        "platform": 0,  // Adjust based on your GPU (0 for AMD)
        "devices": [0]  // Select GPU device(s), 0 for first GPU
    }
}
EOL

# Provide further configuration details
echo "XMRig is set up with basic configuration for both CPU and AMD GPU mining. You may want to manually edit config.json to adjust additional settings."

# Start XMRig (You can choose to start it manually later)
echo "Starting XMRig..."
./xmrig || handle_error "Failed to start XMRig."

# End of script
echo "Setup completed successfully!"
