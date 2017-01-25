# Jenkins scripts

Generic Jenkins helper build scripts. The main script is **pkg-build-mock**.

For package builds, the nodes needs to be properly setup first (gpg key, mini-dinstall/dput configuration, packages, ...).

See also [https://forge.puppetlabs.com/cesnet/jenkins\_node](https://forge.puppetlabs.com/cesnet/jenkins_node).

## Setup

*config.sh*: environment variables:

 * **GPG\_KEY\_URL**: GPG key URL
 * **KEY\_ID**: GPG key ID
 * **PLATFORMS**: supported platforms
 * ...

*repos.sh*: external repositories generator

## Scripts

### `launch-slave`

Script to launch Jenkins slave on the host, only for Jenkins master.

It requires access from master to the slave through ssh (for example using kerberos or ssh keys).

Example:

    /var/lib/jenkins/scripts/launch-slave jenkins myriad19.zcu.cz /var/lib/jenkins

### `pkg-build-copr`

Build rpm package in COPR buildsystem. copr-cli needs to be installed credentials configured.

### `pkg-build-mock`

Script to build binary packages from prepared source packages in chroot
environment by distribution tools (mock, pbuilder).

Local build, local temporary external, and external repositories are supported.

Configured GPG with imported private key is recommended.

Example:

    pkg-build-mock -p debian-8-x86_64 --clean
    pkg-build-mock -p debian-8-x86_64 --add cache/*.changes
    pkg-build-mock -p debian-8-x86_64 --build package_*.dsc

    pkg-build-mock -p epel-7-x86_64 --clean
    pkg-build-mock -p epel-7-x86_64 --add cache/*.rpm
    pkg-build-mock -p epel-7-x86_64 --build package-*.src.rpm

It requires configuration and created chroot environment:

    pkg-build-mock -p debian-8-x86_64 --image

    pkg-build-mock -p epel-7-x86_64 --image

### `pkg-repo`

Helper script (used also by `pkg-build-mock`) to upload packages into local repositories. It also generate repo-files for Jenkins, if `$BUILD_TAG` and `$BUILD_URL` environment variables are available.

Example:

    pkg-repo -p debian-8-x86_64 --clean
    pkg-repo -p debian-8-x86_64 --external --add cache/*.changes
    pkg-repo -p debian-8-x86_64 --add results/*.changes

    pkg-repo -p epel-7-x86_64 --clean
    pkg-repo -p epel-7-x86_64 --external --add cache/*.rpm
    pkg-repo -p epel-7-x86_64 --add results/*.rpm

There are also options `--setup-system` and `--setup-chroot` to setup local repositories to be used by the build process.

#### External repositories

They are specified by *repos.sh* generator. *repos.sh* file in the current build directory takes precedence, otherwise generator from the scripts base directory is used.

#### Pbuilder (Debian, Ubuntu)

Additional pbuilder hook scripts can be installed into *pbuilder/* subdirectory in current build directory.

### `pkg-buildsrc-deb`

Make source package from debian/ directory and source tarball.

### `pkg-buildsrc-rpm`

Make source package from .spec file and source tarball.

### `pkg-bump`

Set version of the source package.

### `refresh-chroot`

Create or refresh chroot environments specified in *PLATFORMS* variable in *config.sh*.
