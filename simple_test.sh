#!/bin/bash

# Simple test suite for nq

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0

test_case() {
    echo -e "${CYAN}[TEST] $1${NC}"
    if eval "$2"; then
        echo -e "${GREEN}[PASS] $1${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}[FAIL] $1${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
}

echo -e "${CYAN}=== nq Simple Test Suite ===${NC}"
echo

# Basic functionality tests
test_case "Help flag works" './nq -h | grep -q "Natural Language Network Query Tool"'
test_case "Version flag works" './nq -v | grep -q "nq version"'
test_case "No args shows error" './nq 2>&1 | grep -q "Please provide a natural language instruction"'

# Test with API key if available
if [[ -n "$GEMINI_API_KEY" || -n "$OPENAI_API_KEY" || -n "$ANTHROPIC_API_KEY" || -n "$NQ_USE_BEDROCK" ]]; then
    echo -e "${CYAN}=== API Tests ===${NC}"
    
    test_case "Provider detection works" './nq "test" 2>&1 | grep -q "Using"'
    test_case "Command generation works" './nq -y "ping google.com" 2>&1 | grep -q "Generated command:"'
    test_case "DNS command works" './nq -y "lookup dns for google.com" 2>&1 | grep -q "dig\|nslookup"'
    test_case "IPv4 command works" './nq -y "show my ipv4" 2>&1 | grep -q "curl"'
    test_case "Debug mode works" './nq -d -y "test" 2>&1 | grep -q "Generated command:"'
    
    echo -e "${CYAN}=== Execution Tests ===${NC}"
    test_case "Ping execution works" './nq -y "ping google.com once" >/dev/null 2>&1'
    test_case "DNS lookup works" './nq -y "lookup google.com" >/dev/null 2>&1'
else
    echo -e "${CYAN}No API key found - skipping API tests${NC}"
fi

echo -e "${CYAN}=== Summary ===${NC}"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed${NC}"
    exit 1
fi