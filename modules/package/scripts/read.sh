#!/usr/bin/env bash

if ! dpkg -l "${PACKAGE_NAME}" | grep -q "ii  ${PACKAGE_NAME}"; then
    echo "{ \"name\": \"${PACKAGE_NAME}\", \"version\": \"\", \"md5sum\": \"\", \"summary\": \"\" }"
else
    dpkg-query -W -f='{ "name": "${binary:Package}","version": "${Version}", "md5sum": "${MD5sum}", "summary": "${binary:Summary}" }\n' "${PACKAGE_NAME}"
fi
