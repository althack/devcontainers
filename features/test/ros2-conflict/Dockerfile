FROM ros:jazzy-ros-base

COPY features/src/ros2 /tmp/ros2-feature

RUN if DISTRO=kilted /tmp/ros2-feature/install.sh >/tmp/conflict.log 2>&1; then \
        cat /tmp/conflict.log; \
        echo "Conflicting ROS distributions unexpectedly succeeded." >&2; \
        exit 1; \
    else \
        grep -F "Refusing to create a mixed ROS environment" /tmp/conflict.log; \
    fi
