FROM ubuntu:22.04

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    dnsutils \
    net-tools \
    iputils-ping \
    traceroute \
    netcat \
    lsof \
    openssl \
    iproute2 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf aws awscliv2.zip

# Create working directory
WORKDIR /app

# Copy nq and test files
COPY nq simple_test.sh ./

# Make scripts executable
RUN chmod +x nq simple_test.sh

# Default command
CMD ["/bin/bash"]