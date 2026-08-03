#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "ROS 2 automatically selects Jazzy on Noble" bash -lc '[ "${ROS_DISTRO:-}" = "jazzy" ]'
check "ROS 2 CLI is installed" bash -lc 'ros2 pkg prefix rclcpp >/dev/null'
check "ROS 2 desktop is installed by default" bash -lc 'ros2 pkg prefix rviz2 >/dev/null'
check "colcon is installed" bash -lc 'command -v colcon >/dev/null'
check "rosdep is installed" bash -lc 'command -v rosdep >/dev/null'
check "vcs is installed" bash -lc 'command -v vcs >/dev/null'
check "rosdep is initialized" test -f /etc/ros/rosdep/sources.list.d/20-default.list
check "ROS profile is installed" test -f /etc/profile.d/ros2.sh

reportResults
