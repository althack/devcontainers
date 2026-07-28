# Linux X11 Forwarding (linux-x11-forwarding)

Forward a local Linux host's X11 display into a development container.

## Example Usage

```json
"features": {
    "ghcr.io/althack/devcontainers/linux-x11-forwarding:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| x11Display | Set DISPLAY for X11 clients launched from the container. | string | :0 |
| softwareGL | Set LIBGL_ALWAYS_SOFTWARE for GPU compatibility. | string | 1 |

## Linux host requirements

This Feature supports containers running locally on a Linux desktop with Xorg or
Wayland/XWayland. It does not configure a host X server and does not support
Docker Desktop on macOS or Windows, remote Docker daemons, or Codespaces.

The container is granted access to the host X server. Only use it with
development containers you trust.

## Xauthority

For modern Wayland/XWayland desktops, the feature auto-discovers the mounted
`.mutter-Xwaylandauth.*` file from `XDG_RUNTIME_DIR`.

For classic Xorg setups where the authority file lives outside
`XDG_RUNTIME_DIR` (often `~/.Xauthority`), add an explicit mount in the consuming
`devcontainer.json`:

```json
"mounts": [
  "source=${localEnv:XAUTHORITY},target=/tmp/devcontainer-xauthority-host,type=bind,readonly"
]
```

The feature always exposes the stable in-container path
`/tmp/devcontainer-xauthority` through `XAUTHORITY`.

Qt applications are forced onto the X11 backend with `QT_QPA_PLATFORM=xcb` so
they do not try to boot the Wayland plugin in X11-only containers.

If the container does not already define `XDG_RUNTIME_DIR`, the Feature creates
a private per-user directory at `/tmp/devcontainer-runtime-<uid>`. The mounted
host runtime directory remains separate and is used only for host sockets and
XWayland authentication.

Use the `x11Display` option to set the in-container `DISPLAY` value.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/althack/devcontainers/blob/main/features/src/linux-x11-forwarding/devcontainer-feature.json). Add additional notes to a `NOTES.md`._
