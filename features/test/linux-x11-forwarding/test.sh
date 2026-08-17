#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "DISPLAY defaults to :0" bash -lc '[ "${DISPLAY:-}" = ":0" ]'
check "XAUTHORITY is set to fixed path" bash -c '[ "${XAUTHORITY:-}" = "/tmp/devcontainer-xauthority" ]'
check "software rendering defaults to enabled" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "Qt uses the X11 backend by default" bash -lc '[ "${QT_QPA_PLATFORM:-}" = "xcb" ]'
check "XDG runtime directory is private and writable" bash -lc '[ "${XDG_RUNTIME_DIR:-}" = "/tmp/devcontainer-runtime-$(id -u)" ] && [ -d "${XDG_RUNTIME_DIR}" ] && [ -w "${XDG_RUNTIME_DIR}" ] && [ "$(stat -c %a "${XDG_RUNTIME_DIR}")" = "700" ]'
check "x11 socket directory exists" bash -c '[ -d /tmp/.X11-unix ]'
check "x11 socket directory is mounted" mountpoint -q /tmp/.X11-unix
check "x11 socket directory is mounted writable" bash -lc 'findmnt -T /tmp/.X11-unix -no OPTIONS | tr "," "\\n" | grep -qx rw'
check "host runtime directory is mounted read-only" bash -lc 'findmnt -T /tmp/devcontainer-host-runtime -no OPTIONS | tr "," "\\n" | grep -qx ro'
check "host authority mount is read-only" bash -lc 'findmnt -T /tmp/devcontainer-xauthority-host -no OPTIONS | tr "," "\\n" | grep -qx ro'
check "xauthority file resolves after shell init" bash -lc '[ -e /tmp/devcontainer-xauthority ]'
check "xauthority uses automatic host file mount" bash -lc '[ "$(readlink /tmp/devcontainer-xauthority)" = "/tmp/devcontainer-xauthority-host" ]'

reportResults
