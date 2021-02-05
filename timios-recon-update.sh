#!/usr/bin/env bash
# Script to download asset file from tag release using GitHub API v3.
# See: http://stackoverflow.com/a/35688093/55075    
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Check dependencies.
set -e
type curl jq >&2
xargs=$(which gxargs || which xargs)

# Validate settings.
[ -f ~/.secrets ] && source ~/.secrets
[ "$GITHUB_API_TOKEN" ] || { echo "Error: Please define GITHUB_API_TOKEN variable." >&2; exit 1; }
[ "$TRACE" ] && set -x

# Define variables.
OWNER="timiosdevelopment"
REPO="atw-pineapple"

CURL="curl -H 'Authorization: token $GITHUB_API_TOKEN' https://api.github.com/repos/$OWNER/$REPO/releases"
ASSET_ID=$(eval "$CURL/tag/latest" | jq .assets[0].id)
eval "$CURL/assets/$ASSET_ID -LJOH 'Accept: application/octet-stream'"
