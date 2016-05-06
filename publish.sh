#!/bin/bash
set -e

VERSION=$(cat version)
RELEASES=( $(cat releases) )

#have to have a branch of the code up there or the packages wont work from the ppa
if [[ "${1}" != "--no-branch" ]]; then
	pushd $(find ${RELEASES[0]}_build/* -maxdepth 0 -type d)
	bzr init
	bzr add
	bzr commit -m "Packaging for ${VERSION}-0ubuntu1."
	bzr push --overwrite lp:~kevinkreiser/+junk/prime-server_${VERSION}-0ubuntu1
	popd
fi

#sign and push each package to launchpad
for release in ${RELEASES[@]}; do
	debsign ${release}_build/*source.changes
	dput ppa:kevinkreiser/prime-server ${release}_build/*source.changes
done
