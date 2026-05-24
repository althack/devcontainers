#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
feature_dir="${repo_root}/features/src/wayland"
feature_metadata="${feature_dir}/devcontainer-feature.json"
feature_install="${feature_dir}/install.sh"
feature_readme="${feature_dir}/README.md"

test -f "${feature_metadata}"
test -f "${feature_install}"
test -f "${feature_readme}"

jq -e '.id == "wayland"' "${feature_metadata}" >/dev/null
jq -e '.name == "Wayland GUI Forwarding"' "${feature_metadata}" >/dev/null
jq -e '.options.softwareGL.default == "1"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.WAYLAND_DISPLAY == "${localEnv:WAYLAND_DISPLAY}"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.XDG_RUNTIME_DIR == "${localEnv:XDG_RUNTIME_DIR}"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.PULSE_SERVER == "${localEnv:PULSE_SERVER}"' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.LIBGL_ALWAYS_SOFTWARE == "${feature:softwareGL}"' "${feature_metadata}" >/dev/null
jq -e '.mounts | index("source=${localEnv:XDG_RUNTIME_DIR},target=${localEnv:XDG_RUNTIME_DIR},type=bind") != null' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.DISPLAY == null' "${feature_metadata}" >/dev/null
jq -e '.containerEnv.XAUTHORITY == null' "${feature_metadata}" >/dev/null

grep -q 'Wayland feature metadata configured.' "${feature_install}"
