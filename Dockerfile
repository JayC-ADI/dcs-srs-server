FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libstdc++6 \
        libgcc-s1 \
        libicu74 \
        ca-certificates \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/srs

COPY SRS-Server-Commandline .
COPY entrypoint.sh .

RUN chmod +x SRS-Server-Commandline entrypoint.sh

LABEL build-id="unique-2025-05-27-r6"

ENTRYPOINT ["./entrypoint.sh"]