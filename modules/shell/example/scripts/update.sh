#!/usr/bin/env bash

root_dirs="$(ls -a /)"

echo "{ \"name\": \"$LC_NAME\", \"description\": \"$LC_DESCRIPTION\", \"root_dirs\": \"$root_dirs\"}"
