
# ROS 2 (ros2)

Install ROS 2 and the tools needed to develop ROS packages.

## Example Usage

```json
"features": {
    "ghcr.io/althack/devcontainers/ros2:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| distro | ROS 2 distribution to install. By default, select the recommended distribution for the container's Ubuntu release. | string | auto |
| package | ROS 2 metapackage to install. | string | desktop |
| workspace | Workspace whose install/setup.sh file should be sourced when present. | string | ${containerWorkspaceFolder} |

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

Compatible ROS installations from `ros:*`, `osrf/ros:*`, and other ROS base
images are reused. An explicit `distro` must agree with any existing
installation; the Feature fails rather than creating a mixed ROS environment.

The Feature provides compiler, debugger, build, version-control, SSH, Python,
rosdep, colcon, vcstool, ament lint, and shell-completion tooling. Graphics,
Gazebo, NVIDIA, CUDA, and host-display integration remain separate concerns.

The Feature's ROS 2-to-Ubuntu compatibility data is stored in
`distributions.json` and packaged with the Feature.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/althack/devcontainers/blob/main/features/src/ros2/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
