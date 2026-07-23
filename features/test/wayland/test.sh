#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "XDG_RUNTIME_DIR defaults to fixed path" bash -c '[ "${XDG_RUNTIME_DIR:-}" = "/tmp/devcontainer-wayland-runtime" ]'
check "WAYLAND_DISPLAY defaults to wayland-0" bash -lc '[ "${WAYLAND_DISPLAY:-}" = "wayland-0" ]'
check "PULSE_SERVER defaults to mounted runtime path" bash -c '[ "${PULSE_SERVER:-}" = "unix:/tmp/devcontainer-wayland-runtime/pulse-native" ]'
check "software rendering defaults through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "runtime directory mount exists" bash -c '[ -d "/tmp/devcontainer-wayland-runtime" ]'
check "runtime directory is mounted" mountpoint -q /tmp/devcontainer-wayland-runtime
check "default wayland socket exists" bash -c '[ -e "/tmp/devcontainer-wayland-runtime/wayland-0" ]'
check "pulse socket exists" bash -c '[ -e "/tmp/devcontainer-wayland-runtime/pulse-native" ]'

reportResults
