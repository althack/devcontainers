#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "existing OSRF Jazzy installation is selected" bash -lc '[ "${ROS_DISTRO}" = jazzy ] && test -d /opt/ros/jazzy'
check "desktop and development capabilities coexist" bash -lc 'command -v rviz2 && command -v colcon && command -v gdb && command -v vcs'

reportResults
