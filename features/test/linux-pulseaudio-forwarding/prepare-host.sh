#!/usr/bin/env bash

set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/tmp/devcontainers-pulseaudio-runtime}"
socket_path="${runtime_dir}/pulse/native"
pid_file="${FEATURE_TEST_PULSE_SOCKET_PID_FILE:-/tmp/devcontainers-pulseaudio-fixture.pid}"
mkdir -p /tmp/.X11-unix "${runtime_dir}/pulse" "$(dirname "${XAUTHORITY:-/tmp/devcontainers-pulseaudio-xauthority.test}")"
chmod 700 "${runtime_dir}"
rm -f "${socket_path}" "${pid_file}"
touch "${runtime_dir}/.mutter-Xwaylandauth.test" "${XAUTHORITY:-/tmp/devcontainers-pulseaudio-xauthority.test}"

python3 - "${socket_path}" <<'PY' &
import signal
import socket
import sys

path = sys.argv[1]
server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(path)
server.listen(1)

def stop(_signum, _frame):
    server.close()
    try:
        __import__("os").unlink(path)
    except FileNotFoundError:
        pass
    raise SystemExit(0)

signal.signal(signal.SIGTERM, stop)
signal.signal(signal.SIGINT, stop)
signal.pause()
PY
pulse_pid=$!
echo "${pulse_pid}" > "${pid_file}"
sleep 0.1
test -S "${socket_path}"

echo "Prepared PulseAudio host socket fixture at ${socket_path} (pid ${pulse_pid})."
