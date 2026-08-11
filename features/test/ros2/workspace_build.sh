#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace="/tmp/ros2_minimal_workspace"

mkdir -p "${workspace}/src"
cp -R "${test_dir}/assets/minimal_package" "${workspace}/src/"
cd "${workspace}"

check "rosdep metadata can be updated" rosdep update
check "workspace dependencies can be resolved" rosdep install --from-paths src --ignore-src --rosdistro "${ROS_DISTRO}" -y
check "minimal workspace builds" colcon build --event-handlers console_direct+

# shellcheck disable=SC1091
source install/setup.bash

check "minimal workspace tests run" colcon test --event-handlers console_direct+
check "minimal workspace tests pass" colcon test-result --verbose
check "installed workspace executable runs" "${workspace}/install/devcontainers_minimal/lib/devcontainers_minimal/devcontainers_minimal_node"

reportResults
