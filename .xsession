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

echo IN'  '`date +"V-%V %c"` >> $HOME/log/xloginlog

xset b off
xrdb -load $HOME/.Xdefaults

case $host in
    jane)
	xmodmap ~/X11/xmodmap/pc
	xmodmap -e 'keycode 108 = Mode_switch'
	;;
    bean)
	xmodmap ~/X11/xmodmap/macbook
	xmodmap -e 'keycode 108 = Mode_switch'
	;;
    *)
	xmodmap ~/X11/xmodmap/pc
	xmodmap -e 'keycode 113 = Mode_switch'
	;;
esac

if [[ -f $HOME/X11/rainlight.gif ]]; then
    xsetbg $HOME/X11/rainlight.gif
else
    xsetroot -solid "#703000"
fi

fvwm

#ssh-agent -k
#

echo OUT' '`date +"V-%V %c"` >> $HOME/log/xloginlog
