#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

mkdir -p /tmp/ros2_overlay/install
printf '%s\n' 'export ROS2_OVERLAY_TEST=loaded' > /tmp/ros2_overlay/install/setup.sh
check "workspace overlay is sourced when present" bash -lc '[ "${ROS2_OVERLAY_TEST:-}" = loaded ]'

reportResults
