#! /bin/bash

subscription-manager repos --enable rhel-7-server-optional-rpms

cat > /etc/yum.repos.d/epel7.repo <<EOF
[epel7]
name=epel 7
baseurl=http://satellite.appl.polisen.se/pulp/repos/Polisen/Library/custom/Extra_Packages_for_Enterprise_Linux/epel7-x86_64/
enabled=1
gpgcheck=0
EOF

yum --enablerepo=epel7 install fvwm rxvt-unicode xmodmap xauth xev emacs \
  xterm perltidy xloadimage xclock gitk ShellCheck perl-LDAP yamllint gitk \
  perl-Tk perl-Sort-Versions

cd /
#tar xf /home/u0043002/pkg/rxvt.tar
