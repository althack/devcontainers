## Additional Notes

Use `distro` to select the Gazebo release and `imageVariant` to choose the container flavor:

- `base`: lighter image for running and testing
- `dev`: includes extra development tooling

The final container image tag is `<distro>-<imageVariant>`. For example:

- `distro=jetty` and `imageVariant=base` uses `althack/gz:jetty-base`

This template uses host networking and host IPC so simulator and robotics tooling can communicate with local services more easily.
