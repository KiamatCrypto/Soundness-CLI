# Soundness CLI Installation Script

## Overview
This Bash script automates the installation process for the Soundness CLI tool, which is required for participating in the Soundness testnet. The script handles all necessary dependencies, installs Rust and the Soundness CLI, and provides an option to generate your testnet key.

## Features
- Automated installation of all dependencies
- Color-coded output for better readability
- Comprehensive error handling
- Optimized for cloud development environments (GitHub Codespaces, Gitpod)
- Interactive key generation
- Clear next steps guidance

## Prerequisites
- Linux/Unix environment (Ubuntu/Debian recommended)
- Basic command-line knowledge
- Internet connection
- Sudo privileges (the script will use sudo when needed)

## Installation Steps
1. Clone this repository or download the script:
   ```bash
   git clone https://github.com/KiamatCrypto/Soundness-CLI
   cd Soundness-CLI
   ```

2. Make the script executable:
   ```bash
   chmod +x soundness.sh
   ```

3. Run the script:
   ```bash
   ./soundness.sh
   ```

## How It Works
The script performs the following actions:
1. Checks for required system tools
2. Updates essential system packages
3. Installs Rust (if not already installed)
4. Verifies Rust and Cargo installation
5. Installs the Soundness CLI
6. Updates the environment variables
7. Provides an option to generate your testnet key

## Example Usage

A typical successful installation will look like this:

```
======================================================
      Welcome to the Soundness Installation Script     
======================================================
This script will install the Soundness CLI and help you generate a key.

Step 1: Checking for required system tools...
All required system tools are available.

...

Step 8: Generating a key...
Would you like to generate a key now? (y/n): y
Enter a name for your key (default: my-key): my-soundness-key

...

====================================================== 
     Soundness Installation Completed Successfully     
======================================================
Next steps:
1. Join Discord: https://discord.gg/ErH3aBHn
2. Verify your account on Discord
3. Enter your Public Key on the #testnet-access channel
Thank you for installing Soundness!
```

## After Installation

After successfully installing the Soundness CLI:

1. Save your mnemonic phrase and public key securely
2. Join the Soundness Discord: https://discord.gg/ErH3aBHn
3. Verify your Discord account
4. Submit your public key in the #testnet-access channel

## Troubleshooting

If you encounter issues with the Soundness CLI commands after installation, try:

```bash
source ~/.bashrc
```

If you're using GitHub Codespaces or Gitpod and encounter repository errors, the script is designed to handle these gracefully and continue with installation.

## Getting Help

If you need additional help:

1. Join the official Soundness Discord: https://discord.gg/ErH3aBHn
2. Open an issue in this repository
