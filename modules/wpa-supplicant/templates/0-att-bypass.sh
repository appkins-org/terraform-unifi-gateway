#!/bin/bash
# This script installs wpa_supplicant if it's not installed.

DATA_DIR="/data/wpa_supplicant"
CONF_DIR="/etc/wpa_supplicant/conf"

if ! dpkg -l wpasupplicant | grep ii >/dev/null; then
    apt update
    apt install -y libreadline8 wpasupplicant
fi

for file in CA.pem Client.pem PrivateKey.pem wpa_supplicant.conf; do
    if [ ! -f "${CONF_DIR}/${file}" ]; then
        cp "${DATA_DIR}/${file}" "${CONF_DIR}"
    fi
done

SERVICE_DIR=/etc/systemd/system/wpa_supplicant.service.d

ONBOOT_DIR=/data/on_boot.d

if [ ! -d "$ONBOOT_DIR" ]; then
    mkdir -p ${ONBOOT_DIR}
fi

if [ ! -d "$SERVICE_DIR" ]; then
    mkdir -p "${SERVICE_DIR}"
fi

cp "${DATA_DIR}"/override.conf "${SERVICE_DIR}/override.conf"

systemctl daemon-reload
systemctl enable wpa_supplicant.service
systemctl restart wpa_supplicant.service
