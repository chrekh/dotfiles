#! /bin/bash

cat > /etc/yum.repos.d/epel8.repo <<EOF
[epel8]
name=epel 8
baseurl=http://satellite.appl.polisen.se/pulp/repos/Polisen/Library/custom/Extra_Packages_for_Enterprise_Linux/EPEL_8/
enabled=0
gpgcheck=0
EOF

subscription-manager repos --enable=codeready-builder-for-rhel-8-x86_64-rpms

yum --enablerepo=epel8 install ShellCheck emacs freetype-devel gcc gitk gitk libX11-devel libXcursor-devel libXft-devel libXpm-devel libXrandr-devel libXt-devel libevent-devel librsvg2-devel perl-LDAP perl-Sort-Versions perl-Tk perltidy readline-devel rxvt-unicode xauth xclock xev xloadimage xmodmap xterm yamllint
