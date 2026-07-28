#!/usr/bin/env bash
set -euo pipefail

test "${ROS_DISTRO:-}" = "jazzy"
test "$(id -un)" = "ros"
ros2 --help >/dev/null
