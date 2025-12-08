# Multi-stage Dockerfile for Wisecow

# Build stage: prepare the application assets
FROM debian:bookworm-slim AS builder
WORKDIR /src

# Copy the server script and ensure it is executable
COPY wisecow.sh ./
RUN chmod +x wisecow.sh

# Final stage: minimal runtime with required packages
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies only (no build toolchain)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
      cowsay \
      fortune-mod \
      netcat-openbsd \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create non-root user for security
RUN useradd -r -u 10001 -g nogroup wisecow && \
    mkdir -p /app

# Copy app from builder and set ownership in one step
COPY --from=builder --chown=wisecow:nogroup /src/wisecow.sh /app/wisecow.sh

USER wisecow

# Expose default port
EXPOSE 4499

# Optional: basic container healthcheck (TCP check)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD nc -z 127.0.0.1 4499 || exit 1

# Start the server
CMD ["/app/wisecow.sh"]