#!/bin/bash
TEMPLATE_ID="$1"

set -e

shopt -s dotglob

SRC_DIR="/tmp/${TEMPLATE_ID}"
cp -R "templates/src/${TEMPLATE_ID}" "${SRC_DIR}"

pushd "${SRC_DIR}"

# Configure templates only if `devcontainer-template.json` contains the `options` property.
OPTION_PROPERTY=( $(jq -r '.options' devcontainer-template.json) )

if [ "${OPTION_PROPERTY}" != "" ] && [ "${OPTION_PROPERTY}" != "null" ] ; then  
    OPTIONS=( $(jq -r '.options | keys[]' devcontainer-template.json) )

    if [ "${OPTIONS[0]}" != "" ] && [ "${OPTIONS[0]}" != "null" ] ; then
        echo "(!) Configuring template options for '${TEMPLATE_ID}'"
        for OPTION in "${OPTIONS[@]}"
        do
            OPTION_KEY="\${templateOption:$OPTION}"
            OPTION_VALUE=$(jq -r ".options | .${OPTION} | .default" devcontainer-template.json)

            if [ "${OPTION_VALUE}" = "" ] || [ "${OPTION_VALUE}" = "null" ] ; then
                echo "Template '${TEMPLATE_ID}' is missing a default value for option '${OPTION}'"
                exit 1
            fi

            echo "(!) Replacing '${OPTION_KEY}' with '${OPTION_VALUE}'"
            OPTION_VALUE_ESCAPED=$(sed -e 's/[]\/$*.^[]/\\&/g' <<<"${OPTION_VALUE}")
            find ./ -type f -print0 | xargs -0 sed -i "s/${OPTION_KEY}/${OPTION_VALUE_ESCAPED}/g"
        done
    fi
fi

popd

TEST_DIR="test/${TEMPLATE_ID}"
if [ -d "${TEST_DIR}" ] ; then
    echo "(*) Copying test folder"
    DEST_DIR="${SRC_DIR}/test-project"
    mkdir -p ${DEST_DIR}
    cp -Rp ${TEST_DIR}/* ${DEST_DIR}
    cp -Rp test/test-utils/* ${DEST_DIR}
fi

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli"
npm install --global @devcontainers/cli@0.88.0

if [ "${TEMPLATE_ID}" = "gz" ]; then
    # The Gazebo template composes host-integration Features. Provide the
    # local Feature sources and narrow fixture paths needed for CI validation.
    GZ_RUNTIME_DIR="/tmp/devcontainers-gz-runtime"
    GZ_XAUTHORITY="/tmp/devcontainers-gz-xauthority"
    mkdir -p /tmp/.X11-unix "${GZ_RUNTIME_DIR}/pulse"
    touch "${GZ_RUNTIME_DIR}/pulse/native" "${GZ_RUNTIME_DIR}/.mutter-Xwaylandauth.test" "${GZ_XAUTHORITY}"
    export DISPLAY=":99"
    export XDG_RUNTIME_DIR="${GZ_RUNTIME_DIR}"
    export XAUTHORITY="${GZ_XAUTHORITY}"

    mkdir -p "${SRC_DIR}/.devcontainer/local-features"
    for feature in linux-x11-forwarding linux-pulseaudio-forwarding; do
        cp -R "features/src/${feature}" "${SRC_DIR}/.devcontainer/local-features/${feature}"
        sed -E -i "s#ghcr.io/althack/devcontainers/${feature}:[0-9]+#./local-features/${feature}#g" \
            "${SRC_DIR}/.devcontainer/devcontainer.json"
    done
fi

echo "Building Dev Container"
ID_LABEL="test-container=${TEMPLATE_ID}"
devcontainer up --id-label ${ID_LABEL} --workspace-folder "${SRC_DIR}"
