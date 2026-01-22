#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Installing nq - Natural Language Network Query Tool${NC}"

# Check for curl
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED}Error: curl is required but not installed${NC}" >&2
    exit 1
fi

# Download nq
echo "Downloading nq..."
if curl -fsSL https://raw.githubusercontent.com/insignias/nq/main/nq -o /tmp/nq; then
    echo -e "${GREEN}Downloaded successfully${NC}"
else
    echo -e "${RED}Failed to download nq${NC}" >&2
    exit 1
fi

# Install to /usr/local/bin
install_dir="/usr/local/bin"
if [[ -w "$install_dir" ]]; then
    mv /tmp/nq "$install_dir/nq"
    chmod +x "$install_dir/nq"
else
    echo "Installing to $install_dir (requires sudo)..."
    sudo mv /tmp/nq "$install_dir/nq"
    sudo chmod +x "$install_dir/nq"
fi

echo -e "${GREEN}nq installed successfully!${NC}"
echo
echo -e "${CYAN}Setup Instructions:${NC}"
echo
echo "Choose one of the following providers:"
echo
echo "1. OpenAI:"
echo "   export OPENAI_API_KEY=\"your-openai-api-key\""
echo
echo "2. Anthropic:"
echo "   export ANTHROPIC_API_KEY=\"your-anthropic-api-key\""
echo
echo "3. Google Gemini:"
echo "   export GEMINI_API_KEY=\"your-gemini-api-key\""
echo
echo "4. AWS Bedrock:"
echo "   export NQ_USE_BEDROCK=true"
echo "   # Requires AWS CLI configured with appropriate permissions"
echo
echo "Add the export command to your shell profile (~/.bashrc, ~/.zshrc, etc.)"
echo
echo -e "${CYAN}Usage:${NC}"
echo "   nq check if google.com is reachable"
echo "   nq show my public ip"
echo "   nq -y lookup dns records for github.com"