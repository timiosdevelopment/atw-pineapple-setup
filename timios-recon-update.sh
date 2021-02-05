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
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$OWNER/$REPO"
GH_TARBALL="$GH_REPO/tarball/1.0.0"
AUTH="Authorization: token $GITHUB_API_TOKEN"

# Validate token.
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Download asset file.
echo "Downloading asset..." >&2
curl -LJO -H "$AUTH" "$GH_TARBALL"
echo "$0 done." >&2

TARFILE=$(ls | grep timiosdevelopment-atw-pineapple*.tar.gz -C 1)
NAME=$(basename "$TARFILE" .tar.gz)

echo "Unpacking release to /root/timios-recon/..." >&2
tar -xvf timiosdevelopment-atw-pineapple*.tar.gz "$NAME/" -C /root/timios-recon/
