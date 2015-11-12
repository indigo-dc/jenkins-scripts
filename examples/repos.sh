EXTERNAL_REPOS='debian-6-x86_64 debian-7-x86_64 debian-8-x86_64 ubuntu-14-x86_64 epel-5-x86_64 epel-5-i386 epel-6-x86_64 epel-6-i386 epel-7-x86_64'

if echo "$EXTERNAL_REPOS" | grep -q "\<$PLATFORM\>"; then

	case $PLATFORM in

	epel*|fedora*)
		cat <<EOF
[EGI-external]
name=EMI-3 External Dependencies
baseurl=http://scientific.zcu.cz/repos/EGI-external/$REPO-\$basearch
gpgkey=http://scientific.zcu.cz/repos/RPM-GPG-KEY-valtri
protect=1
priority=40
enabled=1
EOF
		;;

	debian*|ubuntu*)
		cat <<EOF
deb http://scientific.zcu.cz/repos/EGI-external/$OSFAMILY/ $distcodename/
EOF
		;;

	esac

fi
