# devcontainers

Devcontainer templates repository focused on robotics and simulation.

## Included templates

- `templates/src/gz`
- `templates/src/ros2`

The templates are development entry points for the actively maintained
`althack/gz` and `althack/ros2` image collections. ROS 2 is headless by default
so projects can choose their own host GUI integration when needed.

## Included feature

- `features/src/linux-x11-forwarding` (local Linux hosts only)

## Sample configs

- `.devcontainer/gz-smoke/devcontainer.json`
- `.devcontainer/linux-x11-forwarding-smoke/devcontainer.json`

Before using the samples locally, run
`bash .devcontainer/prepare-local-features.sh` so `devcontainer up` can resolve
the unpublished Feature.

On classic Xorg hosts where the authority cookie lives outside
`XDG_RUNTIME_DIR`, add a bind mount to `/tmp/devcontainer-xauthority-host`.
XWayland setups are auto-detected from the mounted runtime directory.

## Workflows

- `.github/workflows/test-pr.yaml`: smoke tests template changes, validates features, and refreshes generated docs on pull requests
- `.github/workflows/release.yaml`: publishes from GitHub release runs, attaches a versioned source bundle to the release, and also supports manual versioned runs with a dry-run mode that only bumps manifests and regenerates docs in the workflow workspace
