#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "software rendering can be disabled through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "0" ]'
check "runtime directory is mounted" mountpoint -q /tmp/devcontainer-wayland-runtime

reportResults
