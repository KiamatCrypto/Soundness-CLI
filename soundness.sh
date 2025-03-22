#!/bin/bash

print_message() {
  local color=$1
  local message=$2
  
  case $color in
    "green") echo -e "\e[32m$message\e[0m" ;;
    "red") echo -e "\e[31m$message\e[0m" ;;
    "yellow") echo -e "\e[33m$message\e[0m" ;;
    "blue") echo -e "\e[34m$message\e[0m" ;;
    *) echo "$message" ;;
  esac
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

handle_error() {
  local error_message=$1
  local is_fatal=${2:-true}
  
  if [ "$is_fatal" = true ]; then
    print_message "red" "ERROR: $error_message"
    print_message "red" "Installation failed. Please check the error message above."
    exit 1
  else
    print_message "yellow" "WARNING: $error_message"
    print_message "yellow" "Continuing installation despite this warning..."
  fi
}

print_message "blue" "======================================================"
print_message "blue" "      Welcome to the Soundness Installation Script     "
print_message "blue" "======================================================"
print_message "yellow" "This script will install the Soundness CLI and help you generate a key."
echo ""

if [ "$EUID" -eq 0 ]; then
  handle_error "Please do not run this script with sudo or as root. It will use sudo when needed."
fi

print_message "yellow" "Step 1: Checking for required system tools..."
for cmd in curl sudo apt; do
  if ! command_exists "$cmd"; then
    handle_error "Required command '$cmd' not found. Please install it and try again."
  fi
done
print_message "green" "All required system tools are available."
echo ""

print_message "yellow" "Step 2: Updating and upgrading system packages..."
print_message "yellow" "Note: We'll continue even if non-critical repository updates fail."

sudo apt update -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true || {
  print_message "yellow" "Some repositories failed to update. This is often normal in cloud development environments."
  print_message "yellow" "Continuing with installation anyway..."
}

print_message "yellow" "Installing essential packages..."
sudo apt install -y build-essential curl git || handle_error "Failed to install essential packages." false

print_message "green" "System package update step completed."
echo ""

print_message "yellow" "Step 3: Installing Rust..."
if command_exists rustc && command_exists cargo; then
  print_message "green" "Rust is already installed."
else
  print_message "yellow" "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || handle_error "Failed to install Rust."
  source "$HOME/.cargo/env" || handle_error "Failed to source Rust environment."
  print_message "green" "Rust installed successfully."
fi
echo ""

print_message "yellow" "Step 4: Verifying Rust and Cargo installation..."
if ! command_exists rustc || ! command_exists cargo; then
  source "$HOME/.cargo/env" || handle_error "Failed to source Rust environment."
fi

rustc --version || handle_error "Rust is not properly installed."
cargo --version || handle_error "Cargo is not properly installed."
print_message "green" "Rust and Cargo are properly installed."
echo ""

print_message "yellow" "Step 5: Ensuring Rust environment is in bashrc..."
if ! grep -q 'source $HOME/.cargo/env' ~/.bashrc; then
  echo 'source $HOME/.cargo/env' >> ~/.bashrc || handle_error "Failed to add Rust environment to bashrc."
  print_message "green" "Added Rust environment to bashrc."
else
  print_message "green" "Rust environment already in bashrc."
fi
source ~/.bashrc 2>/dev/null || source "$HOME/.cargo/env" || handle_error "Failed to source environment."
echo ""

print_message "yellow" "Step 6: Installing soundnessup..."
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash || handle_error "Failed to install soundnessup."

source ~/.bashrc 2>/dev/null || true
print_message "green" "soundnessup installed successfully."
echo ""

if ! command_exists soundnessup; then
  print_message "yellow" "Attempting to locate soundnessup..."
  if [ -f "$HOME/.soundness/bin/soundnessup" ]; then
    export PATH="$HOME/.soundness/bin:$PATH"
    echo 'export PATH="$HOME/.soundness/bin:$PATH"' >> ~/.bashrc
    print_message "green" "Found soundnessup in $HOME/.soundness/bin and added to PATH"
  else
    handle_error "soundnessup command not found. Please check the installation."
  fi
fi

print_message "yellow" "Step 7: Installing and updating soundness..."
soundnessup install || handle_error "Failed to install soundness."
soundnessup update || handle_error "Failed to update soundness."
print_message "green" "Soundness installed and updated successfully."
echo ""

print_message "yellow" "Step 8: Generating a key..."
read -p "Would you like to generate a key now? (y/n): " generate_key
if [ "$generate_key" = "y" ] || [ "$generate_key" = "Y" ]; then
  read -p "Enter a name for your key (default: my-key): " key_name
  key_name=${key_name:-my-key}
  soundness-cli generate-key --name "$key_name" || handle_error "Failed to generate key."
  print_message "green" "Key generated successfully."
  print_message "yellow" "IMPORTANT: Please save your mnemonic phrase and public key in a secure location."
else
  print_message "yellow" "Skipping key generation. You can generate a key later using:"
  print_message "yellow" "  soundness-cli generate-key --name your-key-name"
fi
echo ""

print_message "blue" "======================================================"
print_message "blue" "     Soundness Installation Completed Successfully     "
print_message "blue" "======================================================"
print_message "yellow" "Next steps:"
print_message "yellow" "1. Join Discord: https://discord.gg/ErH3aBHn"
print_message "yellow" "2. Verify your account on Discord"
print_message "yellow" "3. Enter your Public Key on the #testnet-access channel"
print_message "green" "Thank you for installing Soundness!"

print_message "yellow" "If you encounter any issues with the 'soundness-cli' command,"
print_message "yellow" "try executing: source ~/.bashrc"
