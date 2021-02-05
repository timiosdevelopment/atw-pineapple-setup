
if [ -z "$1" ]; then
  echo "Github access token needed"
  exit 1
fi

TOKEN=$1;
OWNER="timiosdevelopment";
REPO="atw-pineapple";

auth_header="-d --header='Authorization: token $TOKEN'";
accept_header="--header='Accept:application/octet-stream'";
ASSET_ID=$(wget "$auth_header" -O - https://api.github.com/repos/$OWNER/$REPO/releases/tags/latest | python3 -c 'import sys, json; print json.load(sys.stdin)["assets"][0]["id"]') && \
  wget "$auth_header" "$accept_header" -O timios-recon.tar.gz https://api.github.com/repos/$OWNER/$REPO/releases/assets/$ASSET_ID;
