#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "existing Jazzy installation is reused" bash -lc '[ "${ROS_DISTRO}" = jazzy ] && test -d /opt/ros/jazzy'
check "complete development environment is available" bash -lc 'command -v ros2 && command -v colcon && command -v rosdep && command -v vcs && command -v gdb && command -v ssh'
check "ROS metapackage remains installed" dpkg-query -W ros-jazzy-ros-base

reportResults
