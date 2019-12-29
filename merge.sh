#!/bin/bash

base="$INPUT_BASE"
target="$INPUT_TARGET"

set -ex
git fetch --unshallow origin \
    "refs/heads/$base:refs/remotes/origin/$base" \
    "refs/heads/$target:refs/remotes/origin/$target" \
    || exit 0
git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
git checkout -B "$base" "origin/$base"
git checkout -B "$target" "origin/$target"
git merge --strategy=ours --no-commit "$base"
git checkout "$base" -- .
git ls-files | grep -F Manifest.toml | xargs git checkout "origin/$target" --
git add .
git commit -m "Merge branch '$base'" || exit 0

# Ref:
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/metadata-syntax-for-github-actions#inputs
