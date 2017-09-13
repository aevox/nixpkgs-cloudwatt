#!/usr/bin/env bash

# Usage example
# URL=http://localhost:30000 bash ci/create-project.sh

set -e

USERNAME=${USERNAME:-admin}
PASSWORD=${PASSWORD:-admin}
PROJECT_NAME="cloudwatt"
JOBSET_NAME="trunk"
URL=${URL:-http://localhost:3000}

mycurl() {
  curl --referer $URL -H "Accept: application/json" -H "Content-Type: application/json" $@
}

echo "Logging to $URL with user" "'"$USERNAME"'"
cat >data.json <<EOF
{ "username": "$USERNAME", "password": "$PASSWORD" }
EOF
mycurl -X POST -d '@data.json' $URL/login -c hydra-cookie.txt

echo -e "\nCreating project:"
cat >data.json <<EOF
{
  "displayname":"Cloudwatt Hydra CI",
  "enabled":"1"
}
EOF
cat data.json
mycurl --silent -X PUT $URL/project/$PROJECT_NAME -d @data.json -b hydra-cookie.txt

echo -e "\nCreating jobset trunk:"
cat >data.json <<EOF
{
  "checkinterval": "60",
  "enabled": "1",
  "visible": "1",
  "nixexprinput": "cloudwatt",
  "nixexprpath": "jobset.nix",
  "inputs": {
    "cloudwatt": {
      "value": "https://github.com/nlewo/nixpkgs-cloudwatt master",
      "type": "git"
    },
    "bootstrap_pkgs": {
      "value": "https://github.com/NixOS/nixpkgs a0e6a891ee21a6dcf3da35169794cc20b110ce05",
      "type": "git"
    }
  }
}
EOF
cat data.json
mycurl --silent -X PUT $URL/jobset/$PROJECT_NAME/$JOBSET_NAME -d @data.json -b hydra-cookie.txt

rm -f data.json hydra-cookie.txt