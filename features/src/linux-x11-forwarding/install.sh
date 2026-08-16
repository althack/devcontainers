#!/usr/bin/env bash
set -euo pipefail

x11_display="${X11DISPLAY:-:0}"
software_gl="${SOFTWAREGL:-true}"

cat >/etc/profile.d/devcontainer-x11-gui.sh <<EOF
host_runtime_dir="/tmp/devcontainer-host-runtime"
mounted_xauthority="/tmp/devcontainer-xauthority-host"
xauthority_target="/tmp/devcontainer-xauthority"

if [ -z "\${XDG_RUNTIME_DIR:-}" ]; then
    container_runtime_dir="/tmp/devcontainer-runtime-\$(id -u)"
    mkdir -p "\${container_runtime_dir}"
    chmod 0700 "\${container_runtime_dir}"
    export XDG_RUNTIME_DIR="\${container_runtime_dir}"
fi

if [ -f "\${mounted_xauthority}" ]; then
    ln -snf "\${mounted_xauthority}" "\${xauthority_target}"
else
    set -- "\${host_runtime_dir}"/.mutter-Xwaylandauth.*
    if [ -e "\$1" ]; then
        ln -snf "\$1" "\${xauthority_target}"
    else
        rm -f "\${xauthority_target}"
    fi
fi

export DISPLAY="${x11_display}"
if [ "${software_gl}" = "1" ] || [ "${software_gl}" = "true" ]; then
    export LIBGL_ALWAYS_SOFTWARE=1
else
    unset LIBGL_ALWAYS_SOFTWARE
fi
export QT_QPA_PLATFORM="xcb"
export XAUTHORITY="\${xauthority_target}"
EOF

chmod 0644 /etc/profile.d/devcontainer-x11-gui.sh

echo "X11 feature metadata configured."
