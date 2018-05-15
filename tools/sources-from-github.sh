# A script that creates a sources.nix skeleton by looking for the latest
# commit in the specified branch.

# The format of this file is
# Attribute Owner Repos Branch
cat >/tmp/tmp.lst <<EOF
controller cloudwatt contrail-controller R3.2-cloudwatt
neutronPlugin cloudwatt contrail-neutron-plugin master
vrouter nlewo contrail-vrouter R3.2-cloudwatt
EOF

echo "# DO NOT EDIT"
echo "# This file has been generated by"
echo "# $ $0"
echo
echo "{pkgs}:"
echo "{"

while read -r ATTRIBUTE OWNER REPOS BRANCH; do
    echo "  # Head of branch $BRANCH of repository github.com/$OWNER/$REPOS at $(date +'%F %T')"
    COMMITID=$(curl --silent https://api.github.com/repos/$OWNER/$REPOS/branches/$BRANCH | jq -r '.commit.sha')
    curl --silent -L https://github.com/$OWNER/$REPOS/archive/$COMMITID.tar.gz > /tmp/tmp.tgz

    rm -rf /tmp/untar.tmp/
    mkdir /tmp/untar.tmp
    tar -C /tmp/untar.tmp/ -xf /tmp/tmp.tgz
    SHA256=$(find /tmp/untar.tmp/ -maxdepth 1 -mindepth 1 -exec nix-hash --type sha256 --base32 '{}' \;)

    echo "  $ATTRIBUTE = pkgs.fetchFromGitHub {"
    echo "    name = \"$ATTRIBUTE\";";
    echo "    owner = \"$OWNER\";";
    echo "    repo = \"$REPOS\";"
    echo "    rev = \"$COMMITID\";"
    echo "    sha256 = \"$SHA256\";"
    echo "  };"
done < /tmp/tmp.lst

echo "}"

rm -f /tmp/tmp.lst
rm -f /tmp/tmp.tgz
rm -rf /tmp/untar.tmp
