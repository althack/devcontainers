# devcontainers

Devcontainer templates repository focused on robotics and simulation.

## Included template

- `templates/src/gz`

## Included features

- `features/src/x11`
- `features/src/wayland`

## Workflows

- `.github/workflows/test-pr.yaml`: smoke tests template changes, validates features, and refreshes generated docs on pull requests
- `.github/workflows/release.yaml`: publishes from GitHub release runs, attaches a versioned source bundle to the release, and also supports manual versioned runs with a dry-run mode that only bumps manifests and regenerates docs in the workflow workspace
