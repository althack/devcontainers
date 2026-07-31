
# ROS 2 (ros2)

ROS 2 development environment backed by the althack/ros2 image collection.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| distro | ROS 2 distribution to use. | string | jazzy |
| imageVariant | Container image variant to use for this ROS 2 distribution. | string | dev |

## Image selection

This template uses the actively maintained
[`althack/ros2`](https://hub.docker.com/r/althack/ros2) image collection.
`distro` and `imageVariant` select the image tag
`<distro>-<imageVariant>`. The default is `jazzy-dev`.

The moving tags follow the latest build of each supported ROS distribution.
For fully reproducible projects, replace the generated image tag with one of
the dated tags published alongside it.

## ROS networking

The template uses host networking and host IPC to support common local ROS
discovery and shared-memory workflows. Review those settings before using the
template with untrusted software.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/althack/devcontainers/blob/main/templates/src/ros2/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
