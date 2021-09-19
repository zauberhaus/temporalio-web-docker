#/bin/sh

VERSION=`cat version.txt`
REPO=https://github.com/temporalio/web.git


if [ ! -d src ] ; then
    git clone -b ${VERSION} --single-branch --depth=1 ${REPO} src
    cd src 
    echo "Checkout tag $VERSION" 
    if [ "$VERSION" != "main" ] && [ ! -z "$VERSION" ] ; then git checkout tags/${VERSION} -b ${VERSION} ; fi
else
    cd src
fi