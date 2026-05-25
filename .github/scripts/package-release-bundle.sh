#!/usr/bin/env bash

set -euo pipefail

version="${1:-}"
output_dir="${2:-dist}"

if [[ -z "${version}" ]]; then
    echo "Usage: $0 <version> [output-dir]" >&2
    exit 1
fi

mkdir -p "${output_dir}"

archive_path="${output_dir}/devcontainers-${version}.tar.gz"

# Archive the tracked workspace as it exists after version stamping and doc generation.
git ls-files -z | tar --null -czf "${archive_path}" -T -

echo "${archive_path}"
