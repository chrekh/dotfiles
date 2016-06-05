#! /bin/bash

. ~/.functions

cd || exit 1
umask 022
case $domain in
    utv.polisen.se)
	dest=/var/lib/puppet/files/UM/homedirs/u0043002
	;;
    appl.polisen.se)
	dest=/var/lib/puppet/files/PROD/homedirs/196603089076
	;;
    *)
	echo "unconfigured domain $domain"
	exit 1
	;;
esac

echo update $dest
git archive HEAD | tar xvfC - $dest
