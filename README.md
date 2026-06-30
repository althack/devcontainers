# devcontainers

Devcontainer templates repository focused on robotics and simulation.

## Included template

- `templates/src/gz`

## Included features

- `features/src/x11`
- `features/src/wayland`

## Sample configs

- `.devcontainer/gz-smoke/devcontainer.json`
- `.devcontainer/x11-smoke/devcontainer.json`
- `.devcontainer/wayland-smoke/devcontainer.json`
  These sample devcontainers only override the dynamic display name. The features themselves now provide fixed in-container paths and default runtime env values.
  Before using them locally, run `bash .devcontainer/prepare-local-features.sh` so `devcontainer up` can resolve the unpublished features from within `.devcontainer/`.
  On classic Xorg hosts where the authority cookie lives outside `XDG_RUNTIME_DIR`, add a bind mount to `/tmp/devcontainer-xauthority-host`; XWayland setups are auto-detected from the mounted runtime directory.

## Workflows

- `.github/workflows/test-pr.yaml`: smoke tests template changes, validates features, and refreshes generated docs on pull requests
- `.github/workflows/release.yaml`: publishes from GitHub release runs, attaches a versioned source bundle to the release, and also supports manual versioned runs with a dry-run mode that only bumps manifests and regenerates docs in the workflow workspace
