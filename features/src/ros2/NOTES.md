## Supported Ubuntu releases

ROS 2 deb packages target a specific Ubuntu release. Choose a compatible base
image for the selected `distro`. The default `auto` setting selects:

| ROS 2 distribution | Ubuntu release |
|---|---|
| Humble | 22.04 (Jammy) |
| Jazzy | 24.04 (Noble) |
| Kilted | 24.04 (Noble) |
| Lyrical | 26.04 (Resolute) |

The installation stops with an explanatory error when the selected ROS 2 and
Ubuntu releases are incompatible. On Ubuntu 24.04, `auto` selects Jazzy because
it is the long-term ROS 2 release; select Kilted explicitly if desired.

The `package` option defaults to the GUI-oriented `desktop` installation. Select
`ros-base` for a smaller installation. In both cases, the Feature installs
`ros-dev-tools`, including common ROS development commands such as `colcon`,
`rosdep`, and `vcs`.

## Shell and workspace setup

The ROS installation is sourced automatically for the existing container user.
If the configured `workspace` contains `install/setup.sh`, that overlay is
sourced afterward. The Feature does not create or replace the container user.

ROS 2 packages installed from debs use Ubuntu's system Python. Conda or a
separately installed Python interpreter may be incompatible with those packages.

The Feature's ROS 2-to-Ubuntu compatibility data is stored in
`distributions.json` and packaged with the Feature.
