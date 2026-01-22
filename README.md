# nq - Natural Language Network Query Tool

A command-line tool that converts natural language instructions into network debugging commands using AI.

## ⚡ Vibe Code Alert

This project was 99% AI-assisted as a fun hack to make network debugging less painful. Tired of remembering `dig` vs `nslookup` syntax? Just ask in plain English. It works, it's useful, and it's provided as-is. Code is ephemeral now-ask your favorite LLM to modify it however you like. PRs welcome but no promises on maintenance!

## Features

- **Natural Language Interface**: Describe what you want to check in plain English
- **Multi-Provider Support**: OpenAI, Anthropic, Google Gemini, or AWS Bedrock
- **Safety First**: Shows generated command and asks for confirmation before execution
- **Tool Detection**: Checks if required tools are installed and suggests installation
- **Colored Output**: Easy-to-read colored terminal output
- **Zero Dependencies**: Uses only curl and standard shell tools

## Installation

### One-liner (recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/insignias/nq/main/install.sh | bash
```

### Manual Installation
```bash
curl -fsSL https://raw.githubusercontent.com/insignias/nq/main/nq -o nq
chmod +x nq
sudo mv nq /usr/local/bin/
```

## Setup

Choose one provider and set the appropriate environment variable:

### OpenAI
```bash
export OPENAI_API_KEY="your-openai-api-key"
```

### Anthropic
```bash
export ANTHROPIC_API_KEY="your-anthropic-api-key"
```

### Google Gemini
```bash
export GEMINI_API_KEY="your-gemini-api-key"
```

### AWS Bedrock
```bash
# Configure AWS credentials first (if not already done)
aws configure
# Or set environment variables:
# export AWS_ACCESS_KEY_ID="your-access-key"
# export AWS_SECRET_ACCESS_KEY="your-secret-key"
# export AWS_DEFAULT_REGION="us-east-1"

export NQ_USE_BEDROCK=true
# Optional: specify custom model (default: amazon.nova-lite-v1:0)
export NQ_BEDROCK_MODEL="amazon.nova-lite-v1:0"

# For cross-region inference models (newer models), use the us. prefix:
export NQ_BEDROCK_MODEL="us.anthropic.claude-3-5-sonnet-20241022-v2:0"
```

Add the export command to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.) to make it permanent.

**Note**: This tool has been tested with **Google Gemini** (recommended - free tier available) and **AWS Bedrock** (amazon.nova-lite-v1:0). OpenAI and Anthropic providers are implemented but untested due to lack of API credits. Contributions welcome to verify these providers!

**Tip**: Larger/better models will provide more accurate command generation. For Bedrock, consider using Claude 3 Haiku or Llama 3.1 70B for improved results.

**Cross-Region Inference**: Newer Bedrock models may only be available via cross-region inference. Use the `us.` prefix for these models (e.g., `us.anthropic.claude-3-5-sonnet-20241022-v2:0`). The tool calls the inference profile from us-west-2, and Bedrock automatically distributes requests across multiple US regions (us-east-1, us-east-2, us-west-2) for optimal throughput.

## Usage Examples

### DNS Queries
```bash
nq lookup dns records for github.com
nq check if example.com has an MX record
nq find the nameservers for google.com
```

### Connectivity Testing
```bash
nq check if google.com is reachable
nq test connection to port 443 on github.com
nq trace route to 8.8.8.8
```

### Port Scanning
```bash
nq scan open ports on localhost
nq check if port 22 is open on 192.168.1.1
nq find what's listening on port 80
```

### HTTP Testing
```bash
nq test if https://api.github.com is responding
nq check http headers for google.com
nq download the homepage of example.com
```

### SSL/TLS
```bash
nq check ssl certificate for github.com
nq verify tls connection to google.com port 443
nq show certificate details for example.com
```

### Network Interfaces
```bash
nq show my network interfaces
nq display my ip address
nq show routing table
```

### Active Connections
```bash
nq show active network connections
nq find processes using port 8080
nq display listening ports
```

## Command Options

- `-y, --yes`: Auto-execute without confirmation
- `-d, --debug`: Show debug output
- `-h, --help`: Show help message
- `-v, --version`: Show version

## Supported Network Tools

| Tool | Purpose | Installation Status |
|------|---------|--------------------|
| `ping` | Connectivity testing | ✅ Pre-installed |
| `curl` | HTTP requests | ✅ Pre-installed |
| `dig` | DNS queries | ✅ Pre-installed |
| `nslookup` | DNS queries | ✅ Pre-installed |
| `netstat` | Network connections | ✅ Pre-installed |
| `lsof` | Open files/ports | ✅ Pre-installed |
| `nc` | Network connections | ✅ Pre-installed |
| `ifconfig` | Network interfaces | ✅ Pre-installed |
| `traceroute` | Route tracing | ✅ Pre-installed |
| `openssl` | SSL/TLS testing | ✅ Pre-installed |
| `nmap` | Port scanning | 📦 Additional install required |
| `ss` | Socket statistics | 📦 Additional install required |
| `tcpdump` | Packet capture | 📦 Additional install required |

## Safety Notes

- **Always review commands**: nq shows the generated command before execution
- **Use `-y` flag carefully**: Only use auto-execute for trusted queries
- **Tool suggestions**: nq will suggest installation commands for missing tools
- **No harmful commands**: The AI is instructed to never generate destructive commands

## Examples in Action

```bash
$ nq check if google.com is reachable
Using Google Gemini
Generated command: ping -c 4 google.com
Execute this command? (y/N): y
Executing: ping -c 4 google.com
PING google.com (142.250.191.14): 56 data bytes
64 bytes from 142.250.191.14: icmp_seq=0 ttl=118 time=12.345 ms
...
Command completed successfully

$ nq -y show my public ip
Using Google Gemini
Generated command: curl -s ifconfig.me
Executing: curl -s ifconfig.me
203.0.113.42
Command completed successfully
```

## Testing

### Local Testing
```bash
# Run tests on your current system
./simple_test.sh
```

### Cross-Platform Testing (Docker)
Test on Linux using Docker (useful for macOS/Windows users):

```bash
# Build the Docker image
docker build --platform linux/arm64 -t nq-test .

# Run interactively with Gemini
docker run -it --platform linux/arm64 \
  -e GEMINI_API_KEY="your-gemini-key" \
  nq-test

# Or with AWS Bedrock
docker run -it --platform linux/arm64 \
  -e AWS_ACCESS_KEY_ID="your-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret" \
  -e AWS_DEFAULT_REGION="us-east-1" \
  -e NQ_USE_BEDROCK=true \
  nq-test

# Inside the container, run tests
./simple_test.sh
```

**Note**: Use `--platform linux/amd64` for Intel/AMD processors, or `--platform linux/arm64` for Apple Silicon (M1/M2/M3).

## Contributing

Issues and pull requests welcome at [GitHub repository](https://github.com/insignias/nq).

## Future Improvements

- **Ollama Support**: Add local LLM support via Ollama for offline access
  ```bash
  # Already compatible! Just set:
  export OPENAI_BASE_URL="http://localhost:11434/v1"
  export OPENAI_MODEL="llama3.2"
  export OPENAI_API_KEY="dummy"  # Ollama doesn't need a real key
  ```

## License

MIT License - see LICENSE file for details.