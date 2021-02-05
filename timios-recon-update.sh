
if [ -z "$1" ]; then
  echo "Github access token needed"
  exit 1
fi

TOKEN=$1
OWNER="timiosdevelopment"
REPO="atw-pineapple"

CURL="curl -H 'Authorization: token $TOKEN' \
      https://api.github.com/repos/$OWNER/$REPO/releases"; \
ASSET_ID=$(eval "$CURL/tags/latest" | jq .assets[0].id); \
eval "$CURL/assets/$ASSET_ID -LJOH 'Accept: application/octet-stream'"

mkdir -p /root/timios-recon/
