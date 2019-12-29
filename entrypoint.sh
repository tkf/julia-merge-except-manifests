#!/bin/bash
set -x
uid="$(stat --format=%u .)"
useradd --uid="$uid" --create-home github-action
exec su github-action /merge.sh "$@"
