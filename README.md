# devcontainers

Devcontainer templates repository focused on robotics and simulation.

## Included template

- `templates/src/gz`

## Included feature

- `features/src/linux-x11-forwarding` (local Linux hosts only)

## Sample configs

- `.devcontainer/gz-smoke/devcontainer.json`
- `.devcontainer/linux-x11-forwarding-smoke/devcontainer.json`
- `.devcontainer/ros2-feature-smoke/devcontainer.json`

Before using the samples locally, run
`bash .devcontainer/prepare-local-features.sh` so `devcontainer up` can resolve
the unpublished Features.

On classic Xorg hosts where the authority cookie lives outside
`XDG_RUNTIME_DIR`, add a bind mount to `/tmp/devcontainer-xauthority-host`.
XWayland setups are auto-detected from the mounted runtime directory.

## Workflows

- `.github/workflows/test-pr.yaml`: smoke tests template changes, validates features, and checks that generated docs are current on pull requests
- `.github/workflows/release.yaml`: publishes Features and Templates with the Dev Container CLI, combines their discovery metadata under one OCI collection, attaches a versioned source bundle to GitHub releases, and supports manual dry runs
