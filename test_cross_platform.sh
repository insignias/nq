#!/bin/bash

# Cross-platform testing script for nq

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== nq Cross-Platform Testing ===${NC}"
echo

# Test on macOS (current system)
echo -e "${CYAN}Testing on macOS...${NC}"
./simple_test.sh
echo

# Test on Linux using Docker
if command -v docker >/dev/null 2>&1; then
    echo -e "${CYAN}Testing on Linux (Docker)...${NC}"
    
    # Build Docker image
    echo "Building Linux test environment..."
    docker build -t nq-test . >/dev/null 2>&1
    
    # Run tests in Linux container
    echo "Running tests in Linux container..."
    docker run --rm \
        -e GEMINI_API_KEY="$GEMINI_API_KEY" \
        nq-test
    
    echo -e "${GREEN}Cross-platform testing completed!${NC}"
else
    echo -e "${RED}Docker not found. Install Docker to test on Linux.${NC}"
    echo "Alternatively, run these commands on a Linux system:"
    echo "  ./simple_test.sh"
    exit 1
fi