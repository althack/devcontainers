#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

check "ROS 2 Kilted is selected" bash -lc '[ "${ROS_DISTRO:-}" = "kilted" ]'
check "ROS 2 CLI is installed" bash -lc 'command -v ros2 >/dev/null'
check "RViz is installed" bash -lc 'ros2 pkg prefix rviz2 >/dev/null'

reportResults
