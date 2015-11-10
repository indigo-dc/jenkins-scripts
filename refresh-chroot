#! /bin/sh -xe

[ -f `dirname $0`/config.sh ] && . `dirname $0`/config.sh

if [ -z "$PLATFORMS" ]; then
    exit 0
fi

d='/tmp/jenkins-chroot-refresh'
rm -fvr ${d}
mkdir ${d}
cd ${d}
for p in $PLATFORMS; do
    ~/scripts/pkg-build-mock -p ${p} --image
    # to prevent starving
    sleep 20
done
