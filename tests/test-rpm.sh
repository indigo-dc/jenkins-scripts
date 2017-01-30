#! /bin/bash -xe

#
# Test rpm build. Usage:
#
# [NO_REFRESH=1] [NO_CLEAN=1] ./test-rpm.sh
#

img='indigodatacloud/packaging:bcentos_latest'
launchdir=`dirname $0`
name='bcentos_test'
name2='bcentos_test2'
DOCKER="docker exec --user jenkins $name"
PKG_BUILD="$DOCKER /scripts/pkg-build-root --dir /home/jenkins --platform epel-7-x86_64 --root-cmd sudo --no-sign"
DOCKER2="docker exec $name2"
PKG_BUILD2="$DOCKER2 /scripts/pkg-build-root --dir /root --platform epel-7-x86_64 --no-sign"

[ -z "$NO_REFRESH" ] && docker pull $img

# docker volume & SELinux
selinuxenabled && chcon -Rt svirt_sandbox_file_t "$launchdir"/.. || :

# user build with sudo
rm -rf test1/
docker rm -f "$name" 2>/dev/null || :
docker run -itd --name "$name" -v `pwd`/..:/scripts "$img"
# no additional repositories
$DOCKER bash -xc '/usr/bin/touch ~/repos.sh'
$DOCKER bash -c 'cd ~jenkins; /scripts/tests/make-rpms.sh; rm -rf ~jenkins/rpmbuild/'
$PKG_BUILD --setup
! $PKG_BUILD --build /home/jenkins/nonexistant.src.rpm
$PKG_BUILD --build /home/jenkins/test-dep-1.0.0-1.el7.centos.src.rpm
$PKG_BUILD --build /home/jenkins/test-main-1.0.0-1.el7.centos.src.rpm
mkdir test1
$DOCKER bash -c 'cd ~jenkins; cp -rvp results/ reports/ list.txt /scripts/tests/test1/ && sudo chown -R `id -u` /scripts/tests/test1/'

# root build without sudo
rm -rf test2/
docker rm -f "$name2" 2>/dev/null || :
docker run -itd --name "$name2" -v `pwd`/..:/scripts "$img"
# no additional repositories
$DOCKER2 bash -xc '/usr/bin/touch ~/repos.sh'
$DOCKER2 bash -c 'cd ~; /scripts/tests/make-rpms.sh; rm -rf ~/rpmbuild/'
$DOCKER2 bash -xc '/usr/bin/touch ~/repos.sh'
$PKG_BUILD2 --setup
! $PKG_BUILD2 --build /root/nonexistant.src.rpm
$PKG_BUILD2 --build /root/test-dep-1.0.0-1.el7.centos.src.rpm
$PKG_BUILD2 --build /root/test-main-1.0.0-1.el7.centos.src.rpm
mkdir test2
$DOCKER2 bash -xc "cd /root; cp -rvp results/ reports/ list.txt /scripts/tests/test2/ && chown -R `id -u` /scripts/tests/test2/"

# expected results
for test in test1 test2; do
    [ -s "$test"/list.txt ]
    [ -s "$test"/reports/test-dep-build.log ]
    [ -s "$test"/reports/test-dep-root.log ]
    [ -s "$test"/reports/test-main-build.log ]
    [ -s "$test"/reports/test-main-root.log ]
    [ -s "$test"/results/test-dep-*.noarch.rpm ]
    [ -s "$test"/results/test-dep-*.src.rpm ]
    [ -s "$test"/results/test-main-*.noarch.rpm ]
    [ -s "$test"/results/test-main-*.src.rpm ]
    [ `wc -l "$test"/reports/success.log | cut -d' ' -f1` -eq 2 ]
done

[ -z "$NO_CLEAN" ] && docker rm -f "$name" || :
[ -z "$NO_CLEAN" ] && docker rm -f "$name2" || :
