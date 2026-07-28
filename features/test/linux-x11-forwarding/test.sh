#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "DISPLAY defaults to :0" bash -lc '[ "${DISPLAY:-}" = ":0" ]'
check "XAUTHORITY is set to fixed path" bash -c '[ "${XAUTHORITY:-}" = "/tmp/devcontainer-xauthority" ]'
check "PULSE_SERVER is set to mounted runtime path" bash -c '[ "${PULSE_SERVER:-}" = "unix:/tmp/devcontainer-host-runtime/pulse-native" ]'
check "software rendering defaults through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "Qt uses the X11 backend by default" bash -lc '[ "${QT_QPA_PLATFORM:-}" = "xcb" ]'
check "XDG runtime directory is private and writable" bash -lc '[ "${XDG_RUNTIME_DIR:-}" = "/tmp/devcontainer-runtime-$(id -u)" ] && [ -d "${XDG_RUNTIME_DIR}" ] && [ -w "${XDG_RUNTIME_DIR}" ] && [ "$(stat -c %a "${XDG_RUNTIME_DIR}")" = "700" ]'
check "x11 socket directory exists" bash -c '[ -d /tmp/.X11-unix ]'
check "x11 socket directory is mounted" mountpoint -q /tmp/.X11-unix
check "runtime directory is mounted" mountpoint -q /tmp/devcontainer-host-runtime
check "xauthority file resolves after shell init" bash -lc '[ -e /tmp/devcontainer-xauthority ]'
check "xauthority falls back to XWayland runtime auth" bash -lc '[ "$(readlink /tmp/devcontainer-xauthority)" = "/tmp/devcontainer-host-runtime/.mutter-Xwaylandauth.test" ]'
check "pulse socket file is reachable through runtime mount" bash -c '[ -e /tmp/devcontainer-host-runtime/pulse-native ]'

reportResults
