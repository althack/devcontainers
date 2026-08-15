#!/usr/bin/env bash

set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/tmp/devcontainers-pulseaudio-runtime}"
mkdir -p /tmp/.X11-unix "${runtime_dir}/pulse" "$(dirname "${XAUTHORITY:-/tmp/devcontainers-pulseaudio-xauthority.test}")"
chmod 700 "${runtime_dir}"
touch "${runtime_dir}/pulse/native" "${runtime_dir}/.mutter-Xwaylandauth.test" "${XAUTHORITY:-/tmp/devcontainers-pulseaudio-xauthority.test}"

echo "Prepared PulseAudio host socket fixture at ${runtime_dir}/pulse/native."
