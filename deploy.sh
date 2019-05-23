#!/usr/bin/env bash

# is a useful one-liner which will give you the full directory name of the script no matter where it is being called from.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#VERSION=$1
PROJECT=kube-featureflag
REPOSITORY=freegroup

cd $DIR

function increment_version() {
 local v=$1
 if [ -z $2 ]; then
    local rgx='^((?:[0-9]+\.)*)([0-9]+)($)'
 else
    local rgx='^((?:[0-9]+\.){'$(($2-1))'})([0-9]+)(\.|$)'
    for (( p=`grep -o "\."<<<".$v"|wc -l`; p<$2; p++)); do
       v+=.0; done; fi
 val=`echo -e "$v" | perl -pe 's/^.*'$rgx'.*$/$2/'`
 echo "$v" | perl -pe s/$rgx.*$'/${1}'`printf %0${#val}s $(($val+1))`/
}

# retrieving the version from the repository works just with dockerhub.io. Artifactory isn't implemented
#
if [ $# -eq 0 ]
then
  echo "no argument supplied - getting version from dockerhub"
  VERSION=$(curl -L --fail "https://hub.docker.com/v2/repositories/${REPOSITORY}/${PROJECT}/tags/?page_size=1000" | jq '.results | .[] | .name' -r | sed 's/latest//' | sort --version-sort | tail -n 1)
  if [ -z "${VERSION}" ]; then
     VERSION=1.0;
  else
     VERSION=$(increment_version $VERSION)
  fi
fi

bash "${DIR}/build.sh" "$VERSION" "$REPOSITORY" "$PROJECT"

# Apply the YAML passed into stdin and replace the version string first
cat $DIR/yaml/deployment.yaml | sed "s/$REPOSITORY\/$PROJECT/$REPOSITORY\/$PROJECT:$VERSION/g" | kubectl apply -f -
