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
