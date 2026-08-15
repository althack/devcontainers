#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

check "PulseAudio server uses stable container path" bash -lc '[ "${PULSE_SERVER:-}" = "unix:/tmp/devcontainer-pulse/native" ]'
check "host PulseAudio socket is mounted" mountpoint -q /tmp/devcontainer-pulse/native
check "stable PulseAudio socket path exists" test -e /tmp/devcontainer-pulse/native
check "X11 display is configured" bash -lc '[ "${DISPLAY:-}" = ":99" ]'
check "X11 socket directory is mounted" mountpoint -q /tmp/.X11-unix
check "X11 authority path is available" test -e /tmp/devcontainer-xauthority

reportResults
