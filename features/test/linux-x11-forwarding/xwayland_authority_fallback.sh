#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

check "software rendering defaults to enabled" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "Xauthority remains on fixed path" bash -c '[ "${XAUTHORITY:-}" = "/tmp/devcontainer-xauthority" ]'
check "Mutter authority is used when host XAUTHORITY is unset" bash -lc '
    [ "$(readlink /tmp/devcontainer-xauthority)" = \
      "/tmp/devcontainer-host-runtime/.mutter-Xwaylandauth.test" ]
'
check "x11 socket directory is mounted writable" bash -lc 'findmnt -T /tmp/.X11-unix -no OPTIONS | tr "," "\\n" | grep -qx rw'
check "host runtime directory is mounted read-only" bash -lc 'findmnt -T /tmp/devcontainer-host-runtime -no OPTIONS | tr "," "\\n" | grep -qx ro'
check "host authority mount is read-only" bash -lc 'findmnt -T /tmp/devcontainer-xauthority-host -no OPTIONS | tr "," "\\n" | grep -qx ro'

reportResults
