
if [ -z "$1" ]; then
  echo "Github access token needed"
  exit 1
fi

TOKEN=$1
OWNER="timiosdevelopment"
REPO="atw-pineapple"

download_file() {
  local file="https://api.github.com/repos/$OWNER/$REPO/contents/$1"

  echo "$file"

  curl --header "Authorization: token $TOKEN" \
       --header "Accept: application/vnd.github.v3.raw" \
       --remote-name \
       --location $file
}


download_file "recon.py"
download_file "timios-recon"

chmod +x ./timios-recon
