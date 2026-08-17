#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

check "ROS 2 Kilted is selected" bash -lc '[ "${ROS_DISTRO:-}" = "kilted" ]'
check "ros-core metapackage is installed" bash -lc 'test "$(dpkg-query -W -f="\${db:Status-Status}" "ros-${ROS_DISTRO}-ros-core")" = installed'
check "ROS 2 tooling is installed" bash -lc 'ros2 pkg prefix rclcpp >/dev/null'

reportResults
