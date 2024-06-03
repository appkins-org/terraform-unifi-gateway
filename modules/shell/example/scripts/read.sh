#!/usr/bin/env bash

root_dirs="$(ls -a /)"

echo "{ \"name\": \"$NAME\", \"description\": \"$DESCRIPTION\", \"root_dirs\": \"$root_dirs\"}"
