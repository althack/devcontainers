
# X11 GUI Forwarding (x11)

Configure container environment and mounts for host X11 display forwarding.

## Example Usage

```json
"features": {
    "ghcr.io/althack/devcontainers/x11:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| display | Set DISPLAY for X11 clients launched from the container. | string | :0 |
| softwareGL | Set LIBGL_ALWAYS_SOFTWARE for GPU compatibility. | string | 1 |

For modern Wayland/XWayland desktops, the feature auto-discovers the mounted `.mutter-Xwaylandauth.*` file from `XDG_RUNTIME_DIR`.

For classic Xorg setups where the authority file lives outside `XDG_RUNTIME_DIR` (often `~/.Xauthority`), add an explicit mount in the consuming `devcontainer.json`:

```json
"mounts": [
  "source=${localEnv:XAUTHORITY},target=/tmp/devcontainer-xauthority-host,type=bind,readonly"
]
```

The feature always exposes the stable in-container path `/tmp/devcontainer-xauthority` through `XAUTHORITY`.

Qt applications are forced onto the X11 backend with `QT_QPA_PLATFORM=xcb` so they do not try to boot the Wayland plugin in X11-only containers.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/althack/devcontainers/blob/main/features/src/x11/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
