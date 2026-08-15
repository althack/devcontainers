FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

COPY features/src/ros2 /tmp/ros2-feature

ENV DISTRO=jazzy \
    PACKAGE=ros-base \
    _REMOTE_USER=vscode \
    _REMOTE_USER_HOME=/home/vscode

RUN /tmp/ros2-feature/install.sh
RUN /tmp/ros2-feature/install.sh

RUN bash -lc 'test "${ROS_DISTRO}" = jazzy' \
    && bash -lc 'command -v ros2 && command -v colcon && command -v rosdep && command -v vcs' \
    && sudo -u vscode bash -ic 'complete -p colcon >/dev/null' \
    && test -f /etc/ros/rosdep/sources.list.d/20-default.list \
    && test "$(grep -Fc '[ -f /etc/profile.d/ros2.sh ] && . /etc/profile.d/ros2.sh' /home/vscode/.bashrc)" -eq 1 \
    && test "$(grep -Fc '[ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ] && . /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' /home/vscode/.bashrc)" -eq 1
