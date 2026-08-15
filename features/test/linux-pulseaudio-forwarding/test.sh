#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

check "PulseAudio server uses stable container path" bash -lc '[ "${PULSE_SERVER:-}" = "unix:/tmp/devcontainer-pulse/native" ]'
check "host PulseAudio socket is mounted" mountpoint -q /tmp/devcontainer-pulse/native
check "stable PulseAudio socket path exists" test -e /tmp/devcontainer-pulse/native

reportResults
