#!/usr/bin/env bash
set -euo pipefail

features_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
base_image="${DEVCONTAINER_BASE_IMAGE:-mcr.microsoft.com/devcontainers/base:ubuntu}"

if ! command -v devcontainer >/dev/null 2>&1; then
    echo "devcontainer CLI is required. Install it with 'npm install -g @devcontainers/cli'." >&2
    exit 1
fi

cleanup_paths=()

cleanup() {
    for path in "${cleanup_paths[@]}"; do
        if [[ -d "${path}" ]]; then
            rm -rf "${path}"
        elif [[ -f "${path}" ]]; then
            rm -f "${path}"
        fi
    done
}

trap cleanup EXIT

mkdir -p /tmp/.X11-unix

export DISPLAY="${FEATURE_TEST_DISPLAY:-:99}"
export XDG_RUNTIME_DIR="${FEATURE_TEST_XDG_RUNTIME_DIR:-/tmp/devcontainers-wayland-runtime}"
export XAUTHORITY="${FEATURE_TEST_XAUTHORITY:-/tmp/devcontainers-xauthority.test}"
export WAYLAND_DISPLAY="${FEATURE_TEST_WAYLAND_DISPLAY:-wayland-host}"
export PULSE_SERVER="${FEATURE_TEST_PULSE_SERVER:-unix:${XDG_RUNTIME_DIR}/pulse-native}"
xwayland_xauthority="${FEATURE_TEST_XWAYLAND_XAUTHORITY:-${XDG_RUNTIME_DIR}/.mutter-Xwaylandauth.test}"

cleanup_paths+=("${XAUTHORITY}" "${XDG_RUNTIME_DIR}")

mkdir -p "$(dirname "${XAUTHORITY}")"
mkdir -p "${XDG_RUNTIME_DIR}"
chmod 700 "${XDG_RUNTIME_DIR}"
touch "${XAUTHORITY}"
touch "${xwayland_xauthority}"
touch "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}"
touch "${XDG_RUNTIME_DIR}/wayland-0"
touch "${XDG_RUNTIME_DIR}/pulse-native"

for feature in x11 wayland; do
    devcontainer features test \
        --base-image "${base_image}" \
        --features "${feature}" \
        --project-folder "${features_root}"
done
