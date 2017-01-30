#! /bin/sh -xe
launchdir=`dirname $0`

rm -rf /tmp/test-dep /tmp/test-main

cp -a "$launchdir"/test-dep /tmp
(cd /tmp/test-dep; dpkg-buildpackage -uc -us -S -d)

cp -a "$launchdir"/test-main /tmp
(cd /tmp/test-main; dpkg-buildpackage -uc -us -S -d)
