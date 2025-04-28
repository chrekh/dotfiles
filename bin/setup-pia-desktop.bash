#! /bin/bash

if (( EUID == 0 )) ; then
    echo "This is not supposed to run as root"
    exit 1
fi

osfamily=$(facter os.family)

if [[ $osfamily == RedHat ]]; then
  sudo cp ~/pkg/epel8.repo /etc/yum.repos.d
  sudo subscription-manager repos --enable=codeready-builder-for-rhel-8-x86_64-rpms

  sudo yum --color=never --enablerepo=epel8 install ShellCheck emacs freetype-devel gcc gitk libX11-devel libXcursor-devel libXft-devel libXpm-devel libXrandr-devel libXt-devel libevent-devel librsvg2-devel perl-LDAP perl-Tk perltidy readline-devel rxvt-unicode xauth xclock xev xmodmap xterm yamllint perl-Sort-Versions

  cd /tmp || exit
  tar xf ~/X11/fvwm3-1.1.0.tar.gz
  cd /tmp/fvwm3-1.1.0 || exit
  ./configure
  make -j3
  sudo make install

elif [[ $osfamily == Debian ]]; then
  sudo apt install fvwm3 shellcheck emacs gitk perl-doc libnet-ldap-perl perl-tk perltidy rxvt-unicode x11-apps x11-utils xterm yamllint x11-xserver-utils
else
  echo Unsupported osfamily "$osfamily"
  exit 1
fi
