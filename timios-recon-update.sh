
if [ -z "$1" ]; then
  echo "Github access token needed"
  exit 1
fi

TOKEN=$1;
OWNER="timiosdevelopment";
REPO="atw-pineapple";

ASSET_ID=$(wget --header="Authorization: token $TOKEN" -O - https://api.github.com/repos/$OWNER/$REPO/releases/tags/latest | python3 -c 'import sys, json; print json.load(sys.stdin)["assets"][0]["id"]') && \
  wget --header="Authorization: token $TOKEN" --header='Accept:application/octet-stream' -O timios-recon.tar.gz https://api.github.com/repos/$OWNER/$REPO/releases/assets/$ASSET_ID;
