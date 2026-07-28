#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
local_features_dir="${repo_root}/.devcontainer/local-features"

mkdir -p "${local_features_dir}"
rm -rf "${local_features_dir}/linux-x11-forwarding" "${local_features_dir}/x11" "${local_features_dir}/wayland"
cp -R "${repo_root}/features/src/linux-x11-forwarding" "${local_features_dir}/linux-x11-forwarding"

echo "Prepared local smoke-test features in ${local_features_dir}"
