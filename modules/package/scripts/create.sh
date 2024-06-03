#!/usr/bin/env bash

function download_package {
    download_dir="$(mktemp -d)"

    file_name="$(basename "${PACKAGE_URL}")"

    PACKAGE_FILE="${download_dir}/${file_name}"

    curl -sL "${PACKAGE_URL}" -o "${PACKAGE_FILE}"
}

if dpkg -l "${PACKAGE_NAME}" | grep -q "ii  ${PACKAGE_NAME}"; then
    echo "${PACKAGE_NAME} is already installed"
    exit 0
fi

if [[ -n "${PACKAGE_URL}" ]]; then
    # Package URL is set, download the package
    download_package
fi

if [[ -n "${PACKAGE_FILE}" ]]; then
    # Package file is set, install the package from the file
    install_mode="file"
    if [[ ! -f "${PACKAGE_FILE}" ]]; then
        echo "Package file not found"
        exit 1
    fi
else
    install_mode="apt"
fi

case "${install_mode}" in
apt)
    apt-get update
    apt-get install -y "${PACKAGE_NAME}"
    ;;
file)
    dpkg -i "${PACKAGE_FILE}"
    ;;
*)
    echo "Invalid install mode"
    exit 1
    ;;
esac
