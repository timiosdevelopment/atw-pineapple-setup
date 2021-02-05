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
owner="timiosdevelopment"
repo="atw-pineapple"
tag="1.0.0"
names=("recon.py" "report-upload-mipsel" "timios-recon")
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
GH_TAGS="$GH_REPO/releases/tags/$tag"
AUTH="Authorization: token $GITHUB_API_TOKEN"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

echo "Checking if /root/timios-recon/ is created"
mkdir -p /root/timios-recon/
cd /root/timios-recon/

# Validate token.
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

for name in ${names[@]}; do
	# Read asset tags.
	response=$(curl -sH "$AUTH" $GH_TAGS)
	# Get ID of the asset based on given name.
	id=$(echo "$response" | jq --arg name "$name" '.assets[] | select(.name == $name).id')
	[ "$id" ] || { echo "Error: Failed to get asset id, response: $response" | awk 'length($0)<100' >&2; exit 1; }
	GH_ASSET="$GH_REPO/releases/assets/$id"

	# Remove local file
	if [ -f "$name" ]; then
		rm $name
	fi

	# Download asset file.
	echo "Downloading asset ($name)..." >&2
	curl $CURL_ARGS -H "Authorization: token $GITHUB_API_TOKEN" -H 'Accept: application/octet-stream' "$GH_ASSET"
done

if [ -f "timios-recon" ]; then
	chmod +x timios-recon
fi
if [ -f "report-upload-mipsel" ]; then
	chmod +x report-upload-mipsel
fi

echo "Installing timios-recon startup script"
if [ -f "/etc/init.d/timios-recon" ]; then
	echo "Disabling current timios-recon startup script"
	rm /etc/rc.d/*timios-recon
	rm /etc/init.d/timios-recon
fi

cp ./timios-recon /etc/init.d/timios-recon
/etc/init.d/timios-recon enable

echo "$0 done." >&2
