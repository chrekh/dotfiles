#! /bin/sh
host=$(hostname -s)
case $host in
    vdx*)
	export LD_PRELOAD=/usr/lib64/libctxXrandrhook.so
	;;
esac
exec >$HOME/.xsessionlog 2>$HOME/.xsessionlog
#sleep 5
ssh-add -l
xauth list
#sleep 5

test -r $HOME/.bash_profile && . $HOME/.bash_profile

xset b off
xrdb -load $HOME/.Xdefaults

xmodmap $HOME/X11/xmodmap/pc

if [[ -f $HOME/X11/rainlight.gif ]]; then
    xsetbg $HOME/X11/rainlight.gif
else
    xsetroot -solid "#703000"
fi

fvwm
