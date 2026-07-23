#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "WAYLAND_DISPLAY can be overridden from feature option" bash -lc '[ "${WAYLAND_DISPLAY:-}" = "wayland-host" ]'
check "XDG_RUNTIME_DIR stays on fixed path" bash -c '[ "${XDG_RUNTIME_DIR:-}" = "/tmp/devcontainer-wayland-runtime" ]'
check "PULSE_SERVER stays on fixed path" bash -c '[ "${PULSE_SERVER:-}" = "unix:/tmp/devcontainer-wayland-runtime/pulse-native" ]'
check "software rendering defaults through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "wayland socket placeholder exists" bash -c '[ -e "/tmp/devcontainer-wayland-runtime/wayland-host" ]'
check "runtime directory is mounted" mountpoint -q /tmp/devcontainer-wayland-runtime

reportResults
