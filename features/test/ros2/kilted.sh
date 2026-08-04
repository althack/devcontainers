#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "ROS 2 Kilted is selected" bash -lc '[ "${ROS_DISTRO:-}" = "kilted" ]'
check "ROS 2 CLI is installed" bash -lc 'ros2 pkg prefix rclcpp >/dev/null'
check "development tools are installed" bash -lc 'command -v colcon >/dev/null && command -v rosdep >/dev/null && command -v vcs >/dev/null'

reportResults
