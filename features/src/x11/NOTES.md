For modern Wayland/XWayland desktops, the feature auto-discovers the mounted `.mutter-Xwaylandauth.*` file from `XDG_RUNTIME_DIR`.

For classic Xorg setups where the authority file lives outside `XDG_RUNTIME_DIR` (often `~/.Xauthority`), add an explicit mount in the consuming `devcontainer.json`:

```json
"mounts": [
  "source=${localEnv:XAUTHORITY},target=/tmp/devcontainer-xauthority-host,type=bind,readonly"
]
```

The feature always exposes the stable in-container path `/tmp/devcontainer-xauthority` through `XAUTHORITY`.

Qt applications are forced onto the X11 backend with `QT_QPA_PLATFORM=xcb` so they do not try to boot the Wayland plugin in X11-only containers.
