#!/usr/bin/env bash

set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/tmp/devcontainers-pulseaudio-runtime}"
mkdir -p "${runtime_dir}/pulse"
chmod 700 "${runtime_dir}"
touch "${runtime_dir}/pulse/native"

echo "Prepared PulseAudio host socket fixture at ${runtime_dir}/pulse/native."
