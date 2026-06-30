#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "software rendering can be disabled through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "0" ]'
check "Qt uses the X11 backend by default" bash -lc '[ "${QT_QPA_PLATFORM:-}" = "xcb" ]'
check "x11 socket directory is mounted" mountpoint -q /tmp/.X11-unix
check "runtime directory is mounted" mountpoint -q /tmp/devcontainer-host-runtime
check "xauthority file resolves after shell init" bash -lc '[ -e /tmp/devcontainer-xauthority ]'
check "pulse socket file is reachable through runtime mount" bash -c '[ -e /tmp/devcontainer-host-runtime/pulse-native ]'

reportResults
