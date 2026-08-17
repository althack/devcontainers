#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "${script_dir}/../.." && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf "${test_root}"' EXIT

run_case() {
    local version="$1"
    local expected_major="$2"
    local case_dir="${test_root}/${version}"
    mkdir -p "${case_dir}/.github/scripts"
    cp -R "${repo_dir}/features" "${case_dir}/features"
    cp -R "${repo_dir}/templates" "${case_dir}/templates"
    cp "${repo_dir}/.github/scripts/set-devcontainer-version.sh" "${case_dir}/.github/scripts/"

    (
        cd "${case_dir}"
        bash .github/scripts/set-devcontainer-version.sh "${version}"
    )

    while IFS= read -r manifest_file; do
        [[ "$(jq -r '.version' "${case_dir}/${manifest_file}")" == "${version}" ]]
    done < <(
        cd "${case_dir}"
        find features/src templates/src -type f \
            \( -name 'devcontainer-feature.json' -o -name 'devcontainer-template.json' \) \
            | sort
    )

    while IFS= read -r internal_reference; do
        [[ "${internal_reference}" =~ ^ghcr\.io/althack/devcontainers/[^:]+:${expected_major}$ ]]
    done < <(
        find "${case_dir}/templates/src" -type f -name '*.json' -print0 \
            | xargs -0 -r -n1 jq -r '.. | strings | select(test("^ghcr\\.io/althack/devcontainers/[^:]+:[^:]+$"))'
    )

    mapfile -t json_files < <(find "${case_dir}" -type f -name '*.json' | sort)
    sha256sum "${json_files[@]}" > "${case_dir}/before.sha256"
    (
        cd "${case_dir}"
        bash .github/scripts/set-devcontainer-version.sh "${version}"
    )
    sha256sum "${json_files[@]}" > "${case_dir}/after.sha256"
    cmp "${case_dir}/before.sha256" "${case_dir}/after.sha256"
}

run_case 1.0.0 1
run_case 2.3.0 2
run_case 2.0.0-rc.1 2

echo "Release version stamping tests passed."
