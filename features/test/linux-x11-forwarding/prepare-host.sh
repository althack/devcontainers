#!/usr/bin/env bash

set -euo pipefail

x11_runtime_dir="${XDG_RUNTIME_DIR:-/tmp/devcontainers-x11-runtime}"
xauthority="${XAUTHORITY:-/tmp/devcontainers-xauthority.test}"
xwayland_xauthority="${FEATURE_TEST_XWAYLAND_XAUTHORITY:-${x11_runtime_dir}/.mutter-Xwaylandauth.test}"
mkdir -p /tmp/.X11-unix "$(dirname "${xauthority}")" "${x11_runtime_dir}"
chmod 700 "${x11_runtime_dir}"
touch "${xauthority}" "${xwayland_xauthority}"

echo "Prepared X11 host fixtures."
