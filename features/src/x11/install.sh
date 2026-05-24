#!/usr/bin/env bash
set -euo pipefail

# Runtime forwarding is configured through feature metadata (containerEnv/mounts).
# Keep install lightweight and deterministic.
echo "X11 feature metadata configured."
