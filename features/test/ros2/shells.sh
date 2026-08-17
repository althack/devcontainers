#!/usr/bin/env bash

set -e
source dev-container-features-test-lib

mkdir -p /tmp/ros2_shell_overlay/install
printf '%s\n' 'export ROS2_SHELL_OVERLAY_TEST=loaded' > /tmp/ros2_shell_overlay/install/setup.sh

check "Bash ROS CLI is available" bash -lc 'command -v ros2 >/dev/null'
check "Bash ROS distribution is available" bash -lc '[ "${ROS_DISTRO:-}" = "jazzy" ]'
check "Bash workspace overlay is sourced" bash -lc '[ "${ROS2_SHELL_OVERLAY_TEST:-}" = loaded ]'
check "Zsh ROS CLI is available" zsh -ic 'command -v ros2 >/dev/null'
check "Zsh ROS distribution is available" zsh -ic '[ "${ROS_DISTRO:-}" = "jazzy" ]'
check "Zsh workspace overlay is sourced" zsh -ic '[ "${ROS2_SHELL_OVERLAY_TEST:-}" = loaded ]'
check "Bash colcon completion is enabled" bash -ic 'complete -p colcon >/dev/null'

reportResults
