#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "ROS distribution is set" bash -lc 'test -n "${ROS_DISTRO:-}"'
check "ROS installation exists" bash -lc 'test -d "/opt/ros/${ROS_DISTRO}"'
check "ROS 2 automatically selects Jazzy on Noble" bash -lc '[ "${ROS_DISTRO}" = jazzy ]'
check "ROS 2 CLI is installed" bash -lc 'command -v ros2 >/dev/null'
check "ROS development commands are installed" bash -lc 'command -v colcon && command -v rosdep && command -v vcs'
check "native development commands are installed" bash -lc 'command -v cmake && command -v gcc && command -v g++ && command -v gdb && command -v git && command -v ssh && command -v python3'
check "ament lint commands are installed" bash -lc 'command -v ament_cpplint && command -v ament_cppcheck && command -v ament_flake8 && command -v ament_pep257 && command -v ament_uncrustify && command -v ament_xmllint'
check "ament cppcheck compatibility is enabled" bash -lc '[ "${AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS:-}" = 1 ]'
check "rosdep is initialized" test -f /etc/ros/rosdep/sources.list.d/20-default.list
check "absent overlay does not break shell startup" bash -lc 'command -v ros2 >/dev/null'
check "effective user bashrc sources ROS profile once" bash -lc 'test "$(grep -Fc "[ -f /etc/profile.d/ros2.sh ] && . /etc/profile.d/ros2.sh" /home/vscode/.bashrc)" -eq 1'

reportResults
