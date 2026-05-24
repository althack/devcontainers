#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
feature_dir="${repo_root}/features/src/x11"
feature_metadata="${feature_dir}/devcontainer-feature.json"
feature_install="${feature_dir}/install.sh"
feature_readme="${feature_dir}/README.md"

test -f "${feature_metadata}"
test -f "${feature_install}"
test -f "${feature_readme}"

jq -e '.id == "x11"' "${feature_metadata}" >/dev/null
jq -e '.name == "X11 GUI Forwarding"' "${feature_metadata}" >/dev/null
jq -e '.options.softwareGL.default == "1"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.DISPLAY == "${localEnv:DISPLAY}"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.XAUTHORITY == "${localEnv:XAUTHORITY}"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.PULSE_SERVER == "${localEnv:PULSE_SERVER}"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.LIBGL_ALWAYS_SOFTWARE == "${feature:softwareGL}"' "${feature_metadata}" >/dev/null
jq -e '.mounts | index("source=/tmp/.X11-unix,target=/tmp/.X11-unix,type=bind") != null' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.WAYLAND_DISPLAY == null' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.XDG_RUNTIME_DIR == null' "${feature_metadata}" >/dev/null

grep -q 'X11 feature metadata configured.' "${feature_install}"
