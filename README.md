# Jenkins scripts

Jenkins helper build scripts. The main script is **pkg-build-mock**.

## launch-slave

Script to launch Jenkins slave on the host.

Example:

    /var/lib/jenkins/scripts/launch-slave.sh jenkins myriad19.zcu.cz /var/lib/jenkins

## pkg-build-copr

Build rpm package in COPR buildsystem. copr-cli package needs to be installed and credentials setup.

## pkg-build-mock

Script to build binary packages from prepared source packages in chroot
environment.

Local build and local external repositories are supported.

Example:

    pkg-build-mock --clean
    pkg-build-mock --add cache/*.changes
    pkg-build-mock package.dsc

    pkg-build-mock --clean
    pkg-build-mock --add cache/*.rpm
    pkg-build-mock package.spec

## pkg-buildsrc-deb

Make source package from debian/ directory and source tarball.

## pkg-buildsrc-rpm

Make source package from .spec file and source tarball.

## pkg-bump

Set version of the source package.

## Example

    name='pOCCI'
    rpmname='python-pOCCI'
    debname='python-pocci'
    version=`sed -e "s/.*=\s*'\(.*\)'.*/\1/" pOCCI/version.py`
    commit=${commit:-`git rev-parse HEAD`}
    
    # source tarball
    wget https://github.com/CESNET/${name}/archive/${commit}/${name}-${commit}.tar.gz
    
    # source rpm
    git clone http://scientific.zcu.cz/git/packaging-rpm-pOCCI.git && cd packaging-rpm-pOCCI
    ${HOME}/scripts/pkg-bump.sh ${rpmname} ${version} ${release}.
    ${HOME}/scripts/pkg-buildsrc-rpm.sh ${rpmname} ${version} ${name}-${commit}.tar.gz *.diff
    mv *.src.rpm ..
    cd ..
    
    # source deb
    git clone http://scientific.zcu.cz/git/packaging-deb-pOCCI.git && cd packaging-deb-pOCCI
    ${HOME}/scripts/pkg-bump.sh ${debname} ${version} ${release}.
    ${HOME}/scripts/pkg-buildpkg-deb.sh ${debname} ${version} ${name}-${commit}.tar.gz
    mv *.dsc *.debian.tar.* *.orig.tar.gz ..
    cd ..

    # COPR (let's not fail here due to chained builds)
    ${HOME}/scripts/pkg-build-copr.sh *.src.rpm || :
