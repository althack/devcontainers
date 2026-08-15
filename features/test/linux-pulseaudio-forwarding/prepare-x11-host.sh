#!/usr/bin/env bash

set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/tmp/devcontainers-pulseaudio-runtime}"
mkdir -p /tmp/.X11-unix "${runtime_dir}"
chmod 700 "${runtime_dir}"
touch "${runtime_dir}/.mutter-Xwaylandauth.test"

echo "Prepared X11 fixtures for the PulseAudio composition scenario."
