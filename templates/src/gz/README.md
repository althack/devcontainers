
# Gazebo (gz)

Gazebo development environment.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| distro | Gazebo distribution to use. | string | jetty |
| imageVariant | Container image variant to use for this Gazebo distro. | string | base |

## Additional Notes

Use `distro` to select the Gazebo release and `imageVariant` to choose the container flavor:

- `base`: lighter image for running and testing
- `dev`: includes extra development tooling

The final container image tag is `<distro>-<imageVariant>`. For example:

- `distro=jetty` and `imageVariant=base` uses `althack/gz:jetty-base`

This template uses host networking and host IPC so simulator and robotics tooling can communicate with local services more easily.

The Gazebo image supplies its ROS 2 environment. The template composes the
Linux X11 forwarding and Linux PulseAudio forwarding Features. The
host-integration Features target native Linux hosts
with X11/XWayland and a PulseAudio-compatible socket; they do not add custom
WSLg, macOS, Windows, or GPU plumbing.

The X11 Feature mounts the host `XAUTHORITY` file read-only when set.
Wayland/XWayland hosts can use the runtime-directory authority discovery
provided by the Feature.

The template inherits the X11 Feature's default of enabling software
rendering with `LIBGL_ALWAYS_SOFTWARE=1`. The template does not override the
Feature's `softwareGL` option. Set `softwareGL` to `false` only when the container has a functional accelerated OpenGL path.

Runtime flags:

- `--network=host` is retained for ROS/Gazebo discovery and communication with
  host services.
- `--ipc=host` is retained for existing Gazebo/ROS shared-memory behavior.
- `--cap-add=SYS_PTRACE` is retained for debugger/profiling workflows.
- `--security-opt=seccomp:unconfined` is retained for the existing simulator
  development image compatibility.
- `--security-opt=apparmor:unconfined` is retained for compatibility with
  hosts that enforce AppArmor policies around simulator processes.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/althack/devcontainers/blob/main/templates/src/gz/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
