#!/usr/bin/env bash
set -euo pipefail

display="${DISPLAY:-:0}"
software_gl="${SOFTWAREGL:-1}"

cat >/etc/profile.d/devcontainer-x11-gui.sh <<EOF
host_runtime_dir="/tmp/devcontainer-host-runtime"
mounted_xauthority="/tmp/devcontainer-xauthority-host"
xauthority_target="/tmp/devcontainer-xauthority"

if [ -e "\${mounted_xauthority}" ]; then
    ln -snf "\${mounted_xauthority}" "\${xauthority_target}"
else
    set -- "\${host_runtime_dir}"/.mutter-Xwaylandauth.*
    if [ -e "\$1" ]; then
        ln -snf "\$1" "\${xauthority_target}"
    else
        rm -f "\${xauthority_target}"
    fi
fi

export DISPLAY="${display}"
export LIBGL_ALWAYS_SOFTWARE="${software_gl}"
export QT_QPA_PLATFORM="xcb"
export XAUTHORITY="\${xauthority_target}"
EOF

chmod 0644 /etc/profile.d/devcontainer-x11-gui.sh

echo "X11 feature metadata configured."
