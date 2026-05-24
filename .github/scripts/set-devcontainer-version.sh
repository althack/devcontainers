#!/usr/bin/env bash

set -euo pipefail

raw_version="${1:-}"

if [[ -z "${raw_version}" ]]; then
    echo "Usage: $0 <version>" >&2
    exit 1
fi

version="${raw_version#v}"

if [[ ! "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]]; then
    echo "Version must look like semver, for example 1.2.3 or 1.2.3-rc.1" >&2
    exit 1
fi

mapfile -t manifest_files < <(
    find features/src templates/src -type f \
        \( -name 'devcontainer-feature.json' -o -name 'devcontainer-template.json' \) \
        | sort
)

if [[ "${#manifest_files[@]}" -eq 0 ]]; then
    echo "No devcontainer manifest files found." >&2
    exit 1
fi

for manifest_file in "${manifest_files[@]}"; do
    tmp_file="$(mktemp)"
    jq --arg version "${version}" '.version = $version' "${manifest_file}" > "${tmp_file}"
    mv "${tmp_file}" "${manifest_file}"
    echo "Updated ${manifest_file} to version ${version}"
done
