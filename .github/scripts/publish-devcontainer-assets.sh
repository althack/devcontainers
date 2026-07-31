#!/usr/bin/env bash

set -euo pipefail

registry="${1:-}"
namespace="${2:-}"

if [[ -z "${registry}" || -z "${namespace}" ]]; then
    echo "Usage: $0 <registry> <namespace>" >&2
    exit 1
fi

for command in devcontainer jq oras; do
    if ! command -v "${command}" >/dev/null 2>&1; then
        echo "${command} is required." >&2
        exit 1
    fi
done

collection_ref="${registry}/${namespace}:latest"
work_dir="$(mktemp -d)"
trap 'rm -rf "${work_dir}"' EXIT

feature_collection_dir="${work_dir}/features"
template_collection_dir="${work_dir}/templates"
combined_collection_dir="${work_dir}/combined"
verified_collection_dir="${work_dir}/verified"
mkdir -p \
    "${feature_collection_dir}" \
    "${template_collection_dir}" \
    "${combined_collection_dir}" \
    "${verified_collection_dir}"

echo "Publishing Features to ${registry}/${namespace}"
devcontainer features publish features/src \
    --registry "${registry}" \
    --namespace "${namespace}"
oras pull "${collection_ref}" --output "${feature_collection_dir}"

echo "Publishing Templates to ${registry}/${namespace}"
devcontainer templates publish templates/src \
    --registry "${registry}" \
    --namespace "${namespace}"
oras pull "${collection_ref}" --output "${template_collection_dir}"

feature_collection="${feature_collection_dir}/devcontainer-collection.json"
template_collection="${template_collection_dir}/devcontainer-collection.json"
combined_collection="${combined_collection_dir}/devcontainer-collection.json"
config_file="${combined_collection_dir}/config.json"

jq -s \
    '{
        sourceInformation: (.[1].sourceInformation // .[0].sourceInformation),
        features: (.[0].features // []),
        templates: (.[1].templates // [])
    }' \
    "${feature_collection}" \
    "${template_collection}" > "${combined_collection}"

printf '{}\n' > "${config_file}"

feature_count="$(find features/src -mindepth 2 -maxdepth 2 -name devcontainer-feature.json | wc -l)"
template_count="$(find templates/src -mindepth 2 -maxdepth 2 -name devcontainer-template.json | wc -l)"

jq -e \
    --argjson feature_count "${feature_count}" \
    --argjson template_count "${template_count}" \
    '(.features | length) == $feature_count and (.templates | length) == $template_count' \
    "${combined_collection}" >/dev/null

echo "Publishing combined collection metadata to ${collection_ref}"
(
    cd "${combined_collection_dir}"
    oras push "${collection_ref}" \
        --config "config.json:application/vnd.devcontainers" \
        --annotation "com.github.package.type=devcontainer_collection" \
        "devcontainer-collection.json:application/vnd.devcontainers.collection.layer.v1+json"
)

oras pull "${collection_ref}" --output "${verified_collection_dir}"
verified_collection="${verified_collection_dir}/devcontainer-collection.json"

jq -e \
    --argjson feature_count "${feature_count}" \
    --argjson template_count "${template_count}" \
    '(.features | length) == $feature_count and (.templates | length) == $template_count' \
    "${verified_collection}" >/dev/null

echo "Verified combined collection metadata with ${feature_count} Feature(s) and ${template_count} Template(s)."
