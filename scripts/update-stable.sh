#!/bin/bash

set -e

latest_stable_release=`curl --silent "https://api.github.com/repos/ledger/ledger/releases/latest" | jq .tag_name | xargs`
latest_stable_revision=`curl --silent "https://api.github.com/repos/ledger/ledger/commits/${latest_stable_release}" | jq .sha | xargs`
latest_stable_version=${latest_stable_release#"v"}

echo "latest stable version: ${latest_stable_version}, revision: ${latest_stable_revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${latest_stable_version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${latest_stable_revision}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${latest_stable_version}, revision ${latest_stable_revision}"

