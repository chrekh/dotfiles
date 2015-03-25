#!/bin/sh

[ -r ~/.functions -a ! "$os" ] && . ~/.functions

export LANG=sv_SE.utf8
export LC_MESSAGES=C

[ $os = Da ] && exec quartz-wm

nice -n 5 xmm -usedcolor "#009900" -activecolor "#0000ff" -inactivecolor "#00cc99" -freecolor "#ffffcc" -swapcolor red -nolabel -jumpscroll 10 -geometry 520x310-1602+2 &

xsetbg /home/che/X11/rainlight.gif
xrdb /home/che/.Xdefaults 

case $host in
    bean)
	xmodmap ~/X11/xmodmap/macbook
	xhost +local:0
	;;
    *)
	xmodmap ~/X11/xmodmap/pc
	;;
esac

[ -x /usr/bin/urxvt ] || uxterm &

xscreensaver -no-capture-stderr -no-splash &

echo ----- $$
echo $$ > /home/che/X11/Xpid/pid
echo ----- $$

fvwm
