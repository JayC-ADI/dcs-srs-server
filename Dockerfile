FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary runtime dependencies including ICU
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libstdc++6 \
        libgcc-s1 \
        libicu72 \
        ca-certificates \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /opt/srs

# Copy SRS binary and entrypoint script
COPY SRS-Server-Commandline .
COPY entrypoint.sh .

# Make binaries executable
RUN chmod +x SRS-Server-Commandline entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]