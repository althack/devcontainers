# devcontainers

Devcontainer templates repository focused on robotics and simulation.

## Included template

- `templates/src/gz`

## Included features

- `features/src/x11`
- `features/src/wayland`

## Workflows

- `.github/workflows/test-pr.yaml`: smoke tests template changes, validates features, and refreshes generated docs on pull requests
- `.github/workflows/release.yaml`: publishes features and templates to GHCR on manual dispatch from `main`
