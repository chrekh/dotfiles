#! /bin/bash

if (( EUID == 0 )) ; then
    echo "This is not supposed to run as root"
    exit 1
fi

sudo cp ~/pkg/epel8.repo /etc/yum.repos.d

sudo subscription-manager repos --enable=codeready-builder-for-rhel-8-x86_64-rpms

sudo yum --enablerepo=epel8 install ShellCheck emacs freetype-devel gcc gitk gitk libX11-devel libXcursor-devel libXft-devel libXpm-devel libXrandr-devel libXt-devel libevent-devel librsvg2-devel perl-LDAP perl-Tk perltidy readline-devel rxvt-unicode xauth xclock xev xmodmap xterm yamllint

cd /tmp
tar xf ~/X11/fvwm3-1.1.0.tar.gz
cd /tmp/fvwm3-1.1.0
./configure
make -j3
sudo make install
