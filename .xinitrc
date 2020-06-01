#!/bin/sh

[ -r ~/.functions -a ! "$os" ] && . ~/.functions

export LANG=sv_SE.utf8
export LC_MESSAGES=C

[ $os = Da ] && exec quartz-wm

nice -n 5 xmm -usedcolor "#009900" -activecolor "#0000ff" -inactivecolor "#00cc99" -freecolor "#ffffcc" -swapcolor red -nolabel -jumpscroll 10 -geometry 520x310-1602+2 &

xrdb /home/che/.Xdefaults 

case $host in
    bean)
	xmodmap ~/X11/xmodmap/macbook
	xmodmap -e 'keycode 108 = Mode_switch'
	;;
    *)
	xmodmap ~/X11/xmodmap/pc
	xmodmap -e 'keycode 113 = Mode_switch'
	;;
esac

echo ----- $$
echo $$ > /home/che/X11/Xpid/pid
echo ----- $$

fvwm
