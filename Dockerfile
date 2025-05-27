# Use Ubuntu 24.04 LTS as the base image
# Ubuntu provides a stable, well-supported Linux environment
FROM ubuntu:24.04

# Set environment variable to avoid interactive prompts during package installation
# This ensures the build process runs smoothly in automated environments
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install required runtime dependencies
# --no-install-recommends: Only install essential packages to keep image size small
# The packages installed are:
#   - libstdc++6: C++ standard library (required for C++ applications)
#   - libgcc-s1: GCC runtime library (required for compiled applications)
#   - libicu74: Unicode support library (for internationalization)
#   - ca-certificates: SSL/TLS certificate authorities (for secure connections)
# Clean up package cache to reduce image size
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libstdc++6 \
        libgcc-s1 \
        libicu74 \
        ca-certificates \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
# All subsequent commands will be executed from this directory
WORKDIR /opt/srs

# Copy the SRS server executable and startup script from the build context
# These files must be present in the same directory as the Dockerfile
COPY SRS-Server-Commandline .
COPY entrypoint.sh .

# Make the copied files executable
# This is necessary because file permissions may not be preserved during COPY
RUN chmod +x SRS-Server-Commandline entrypoint.sh

# Define the default command to run when the container starts
# The entrypoint script will handle the application startup
ENTRYPOINT ["./entrypoint.sh"]