#!/usr/bin/env bash

installed_package_version="$(dpkg-query -W -f='${Version}\n' "${PACKAGE_NAME}" | cut -d '+' -f 1 | cut -d '-' -f 1)"
echo "${installed_package_version}"

function download_package {
    download_dir="$(mktemp -d)"

    file_name="$(basename "${PACKAGE_URL}")"

    PACKAGE_FILE="${download_dir}/${file_name}"

    curl -sL "${PACKAGE_URL}" -o "${PACKAGE_FILE}"
}

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
    apt update
    apt install --only-upgrade -y "${PACKAGE_NAME}"
    ;;
file)
    dpkg -i "${PACKAGE_FILE}"
    ;;
*)
    echo "Invalid install mode"
    exit 1
    ;;
esac
