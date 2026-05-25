#!/usr/bin/env bash
set -euo pipefail

wayland_display="${WAYLANDDISPLAY:-wayland-0}"
software_gl="${SOFTWAREGL:-1}"

cat >/etc/profile.d/devcontainer-wayland-gui.sh <<EOF
export WAYLAND_DISPLAY="${wayland_display}"
export LIBGL_ALWAYS_SOFTWARE="${software_gl}"
EOF

chmod 0644 /etc/profile.d/devcontainer-wayland-gui.sh

echo "Wayland feature metadata configured."
