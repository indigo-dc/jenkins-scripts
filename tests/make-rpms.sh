#! /bin/sh -xe
launchdir=`dirname $0`
topdir=`rpm --eval %_topdir`

for name in 'test-dep' 'test-main'; do
    rpmbuild --nodeps -bs "$launchdir/${name}.spec"
    cp -vp "$topdir"/SRPMS/${name}*.src.rpm .
done
