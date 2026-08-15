## Linux host requirements

This Feature supports local Linux containers only. The host must already
provide a PulseAudio-compatible server socket at
`$XDG_RUNTIME_DIR/pulse/native`, including PipeWire installations using its
PulseAudio compatibility server.

It does not install or configure a host audio server and does not support
macOS, Windows Docker Desktop, remote Docker daemons, Codespaces, or
WSL-specific audio forwarding.

The Feature is useful for applications such as Gazebo that need host audio.
