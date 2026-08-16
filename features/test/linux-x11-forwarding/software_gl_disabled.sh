#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "software rendering remains unset when disabled" bash -lc '[ -z "${LIBGL_ALWAYS_SOFTWARE:-}" ]'
check "Qt uses the X11 backend by default" bash -lc '[ "${QT_QPA_PLATFORM:-}" = "xcb" ]'
check "x11 socket directory is mounted" mountpoint -q /tmp/.X11-unix
check "x11 socket directory is mounted writable" bash -lc 'findmnt -T /tmp/.X11-unix -no OPTIONS | tr "," "\\n" | grep -qx rw'
check "host runtime directory is mounted read-only" bash -lc 'findmnt -T /tmp/devcontainer-host-runtime -no OPTIONS | tr "," "\\n" | grep -qx ro'
check "host authority mount is read-only" bash -lc 'findmnt -T /tmp/devcontainer-xauthority-host -no OPTIONS | tr "," "\\n" | grep -qx ro'
check "xauthority file resolves after shell init" bash -lc '[ -e /tmp/devcontainer-xauthority ]'
reportResults
