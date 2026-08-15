
# Linux PulseAudio Forwarding (linux-pulseaudio-forwarding)

Forward a local Linux host PulseAudio or PipeWire-Pulse socket into a development container.

## Example Usage

```json
"features": {
    "ghcr.io/althack/devcontainers/linux-pulseaudio-forwarding:0": {}
}
```



## Linux host requirements

This Feature supports local Linux containers only. The host must already
provide a PulseAudio-compatible server socket at
`$XDG_RUNTIME_DIR/pulse/native`, including PipeWire installations using its
PulseAudio compatibility server.

It does not install or configure a host audio server and does not support
macOS, Windows Docker Desktop, remote Docker daemons, Codespaces, or
WSL-specific audio forwarding.

The Feature is useful for applications such as Gazebo that need host audio.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/althack/devcontainers/blob/main/features/src/linux-pulseaudio-forwarding/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
