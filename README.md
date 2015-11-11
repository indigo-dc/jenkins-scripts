# Jenkins scripts

Generic Jenkins helper build scripts. The main script is **pkg-build-mock**.

The nodes needs to be properly setup first (gpg key, mini-dinstall/dput configuration, packages, ...).

## launch-slave

Script to launch Jenkins slave on the host, for Jenkins master only.

Example:

    /var/lib/jenkins/scripts/launch-slave jenkins myriad19.zcu.cz /var/lib/jenkins

## pkg-build-copr

Build rpm package in COPR buildsystem. copr-cli package needs to be installed and credentials setup.

## pkg-build-mock

Script to build binary packages from prepared source packages in chroot
environment by distribution tools (mock, pbuilder).

Local build and local external repositories are supported.

Configured GPG with imported private key is recommended.

Example:

    pkg-build-mock -p debian-8-x86_64 --clean
    pkg-build-mock -p debian-8-x86_64 --add cache/*.changes
    pkg-build-mock -p debian-8-x86_64 package.dsc

    pkg-build-mock -p epel-7-x86_64 --clean
    pkg-build-mock -p epel-7-x86_64 --add cache/*.rpm
    pkg-build-mock -p epel-7-x86_64 package.spec

It is needed to create chroot environment first:

    pkg-build-mock -p debian-8-x86_64 --image

    pkg-build-mock -p epel-7-x86_64 --image

### Pbuilder (Debian, Ubuntu)

Additional pbuilder hook scripts can be installed into *pbuilder/* subdirectory in current build directory.

## pkg-buildsrc-deb

Make source package from debian/ directory and source tarball.

## pkg-buildsrc-rpm

Make source package from .spec file and source tarball.

## pkg-bump

Set version of the source package.

## refresh-chroot

Create or refresh chroot environments specified in *PLATFORMS* variable in *config.sh*.
