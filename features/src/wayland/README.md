# Wayland GUI Forwarding (wayland)

Enable desktop app forwarding from a dev container to your host through Wayland.

## Example Usage

```jsonc
{
  "features": {
    "ghcr.io/athackst/devcontainer-templates/wayland:0": {}
  }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| softwareGL | Set LIBGL_ALWAYS_SOFTWARE for GPU compatibility. | string | 1 |
