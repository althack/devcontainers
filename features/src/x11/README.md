# X11 GUI Forwarding (x11)

Enable desktop app forwarding from a dev container to your host through X11.

## Example Usage

```jsonc
{
  "features": {
    "ghcr.io/athackst/devcontainer-templates/x11:0": {}
  }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| softwareGL | Set LIBGL_ALWAYS_SOFTWARE for GPU compatibility. | string | 1 |
