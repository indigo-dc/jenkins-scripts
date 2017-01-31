#! /bin/sh -xe
launchdir=`dirname $0`

rm -rf /tmp/test-dep /tmp/test-main

cp -a "$launchdir"/test-dep /tmp
(cd /tmp/test-dep; dpkg-buildpackage -uc -us -S -d)

cp -a "$launchdir"/test-main /tmp
mkdir /tmp/test-main-1.0.0
install -vp "$launchdir"/test-main/test.txt /tmp/test-main-1.0.0/
(cd /tmp; tar c test-main-1.0.0 | gzip > test-main_1.0.0.orig.tar.gz)
cp -a "$launchdir"/test-main /tmp/test-main-1.0.0
(cd /tmp/test-main; dpkg-buildpackage -uc -us -S -d)
