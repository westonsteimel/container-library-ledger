#!/bin/bash

set -e

latest_stable_release=`curl --silent "https://api.github.com/repos/ledger/ledger/releases/latest" | jq .tag_name | xargs`
revision=`curl --silent "https://api.github.com/repos/ledger/ledger/commits/${latest_stable_release}" | jq .sha | xargs`
version=${latest_stable_release#"v"}

echo "latest stable version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}, revision ${revision}"

version="master"
revision=`curl --silent "https://api.github.com/repos/ledger/ledger/commits/${version}" | jq .sha | xargs`
echo "latest edge version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "edge/Dockerfile"

git add edge/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated edge to version ${version}, revision: ${revision}"
