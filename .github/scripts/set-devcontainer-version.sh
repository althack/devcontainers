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

if [[ "${version}" == "0.0.0" ]]; then
    echo "Version 0.0.0 is reserved for unreleased source manifests." >&2
    exit 1
fi

major="${version%%.*}"

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
    chmod --reference="${manifest_file}" "${tmp_file}"
    mv "${tmp_file}" "${manifest_file}"
    echo "Updated ${manifest_file} to version ${version}"
done

mapfile -t template_json_files < <(find templates/src -type f -name '*.json' | sort)

for json_file in "${template_json_files[@]}"; do
    tmp_file="$(mktemp)"
    jq --arg major "${major}" '
        walk(
            if type == "string" then
                gsub(
                    "ghcr\\.io/althack/devcontainers/(?<feature>[A-Za-z0-9._-]+):0";
                    "ghcr.io/althack/devcontainers/\\(.feature):\\($major)"
                )
            else
                .
            end
        )
    ' "${json_file}" > "${tmp_file}"
    chmod --reference="${json_file}" "${tmp_file}"
    mv "${tmp_file}" "${json_file}"
    echo "Updated internal Feature references in ${json_file} to major ${major}"
done

for manifest_file in "${manifest_files[@]}"; do
    manifest_version="$(jq -r '.version' "${manifest_file}")"
    if [[ "${manifest_version}" != "${version}" ]]; then
        echo "${manifest_file} has version ${manifest_version}; expected ${version}." >&2
        exit 1
    fi
done

while IFS= read -r internal_reference; do
    if [[ ! "${internal_reference}" =~ ^ghcr\.io/althack/devcontainers/[^:]+:${major}$ ]]; then
        echo "${internal_reference} does not use release major ${major}." >&2
        exit 1
    fi
done < <(
    for json_file in "${template_json_files[@]}"; do
        jq -r '.. | strings | select(test("^ghcr\\.io/althack/devcontainers/[^:]+:[^:]+$"))' "${json_file}"
    done
)
