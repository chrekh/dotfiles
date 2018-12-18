#! /bin/bash

cd || exit 1
umask 022
host=`hostname -f`
case $host in
    um-puppet.utv.rps.police.se | capsule*.utv.polisen.se | satellite.utv.polisen.se )
	dest=/var/lib/puppet/files/UM/homedirs/u0043002
	;;
    capsule.dmz.polisen.se )
	dest=/var/lib/puppet/files/DMZ/homedirs/u0043002
	;;
    satellite.appl.polisen.se | capsule*.dc.polisen.se)
	dest=/var/lib/puppet/files/PROD/homedirs/196603089076ll 
	;;
    *)
	echo "No action defined for $host"
	exit 1
	;;
esac

echo update $dest
git archive HEAD | tar xvfC - $dest
