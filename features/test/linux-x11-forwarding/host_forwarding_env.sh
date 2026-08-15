#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "DISPLAY can be overridden from feature option" bash -lc '[ "${DISPLAY:-}" = ":99" ]'
check "XAUTHORITY stays on fixed path" bash -c '[ "${XAUTHORITY:-}" = "/tmp/devcontainer-xauthority" ]'
check "software rendering defaults through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "Qt uses the X11 backend by default" bash -lc '[ "${QT_QPA_PLATFORM:-}" = "xcb" ]'
check "x11 socket directory is mounted" mountpoint -q /tmp/.X11-unix
check "runtime directory is mounted" mountpoint -q /tmp/devcontainer-host-runtime
check "xauthority file resolves after shell init" bash -lc '[ -e /tmp/devcontainer-xauthority ]'
check "xauthority prefers explicit host file mount" bash -lc '[ "$(readlink /tmp/devcontainer-xauthority)" = "/tmp/devcontainer-xauthority-host" ]'
reportResults
