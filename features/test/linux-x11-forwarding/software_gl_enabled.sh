#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

check "software rendering can be enabled through shell init" bash -lc '[ "${LIBGL_ALWAYS_SOFTWARE:-}" = "1" ]'
check "Qt uses the X11 backend by default" bash -lc '[ "${QT_QPA_PLATFORM:-}" = "xcb" ]'

reportResults
