#!/bin/bash

base="$INPUT_BASE"
target="$INPUT_TARGET"

git_fetch_origin() {
    git fetch --unshallow origin "$1" || git fetch origin "$1"
}

set -ex

git branch

# Checkout 'master' first; it seems create-pull-request expect this:
git_fetch_origin "refs/heads/$base:refs/remotes/origin/$base" || true
git checkout -B "$base" "origin/$base"
git branch

git_fetch_origin "refs/heads/$target:refs/remotes/origin/$target" || true
git log -n1 "origin/$target" || exit 0
if [ -n "$GITHUB_ACTOR" ]
then
    git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
    git config --global user.name "$GITHUB_ACTOR"
fi
git checkout -B "$target" "origin/$target"
git merge --strategy=ours --no-commit "$base"
find . -type d -name .git -prune -o -type f -print0 | xargs --null rm -rf
git checkout "$base" -- .
git ls-tree -r --name-only "origin/$target" | grep -F Manifest.toml \
    | xargs git checkout "origin/$target" --
git ls-tree -r --name-only "origin/$target" | grep -F Manifest.toml \
    | xargs git add -f --
git add .
git commit -m "Merge branch '$base'" || exit 0

# Ref:
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/metadata-syntax-for-github-actions#inputs
