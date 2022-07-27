#!/bin/sh

# Xcode Set Environment Task:
# When creating a new xcode scheme add this script as Pre-actions run script.
# `${PROJECT_DIR}/scripts/set-environment.sh Prod`
# Replace Prod with the desired environment.

set -e
TARGET_ENVIRONMENT="$1"

# If PROJECT_DIR not set or null, use current directory.
ROOT_DIR=${PROJECT_DIR:-.}
CLOUD_CONFIG_DIR="${ROOT_DIR}/Cloud"
XCODE_CONFIG_DIR="${ROOT_DIR}/Configurations"

# Use `Prod` as default environment if one not exist
if [ -z "${TARGET_ENVIRONMENT}" ]; then
    TARGET_ENVIRONMENT="Prod"
fi

if [ -z "${SRCROOT}" ]; then
    SRCROOT="${ROOT_DIR}"
fi

if [ -z "${INFOPLIST_FILE}" ]; then
    INFOPLIST_FILE="Info.plist"
fi

copy_xcode_config() {
    local SOURCE="${XCODE_CONFIG_DIR}/${TARGET_ENVIRONMENT}.xcconfig"
    local DESTINATION="${XCODE_CONFIG_DIR}/Active.xcconfig"

    if [ -f "${SOURCE}" ]; then
        echo "// File is generated at build time by set-environment.sh. Do not modify.\n" > "${DESTINATION}"
        echo "#include \"${TARGET_ENVIRONMENT}.xcconfig\"" >> "${DESTINATION}"

        # Tell Xcode to regenerate info.plist.
        touch "${SRCROOT}/${INFOPLIST_FILE}"
    else
        echo "error: Unsupported environment: ${TARGET_ENVIRONMENT}. File not found: ${SOURCE}"
        exit 1
    fi
}

copy_cloud_config() {
    local SOURCE="${CLOUD_CONFIG_DIR}/${TARGET_ENVIRONMENT}"
    local DESTINATION="${SRCROOT}/BetaProd/Cloud"

    if [ -d "${SOURCE}" ]; then
        mkdir -p "${DESTINATION}"
        cp "${SOURCE}"/*.json "${DESTINATION}"
        touch "${DESTINATION}"/*.json
    else
        echo "error: Unsupported environment: ${TARGET_ENVIRONMENT}. Directory not found: ${SOURCE}"
        exit 1
    fi
}

copy_xcode_config
copy_cloud_config

echo "Build set to ${TARGET_ENVIRONMENT} target environment!"
