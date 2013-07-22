#!/bin/sh

export LANG=sv_SE.utf8
export LC_MESSAGES=C

nice -n 5 xmm -usedcolor "#009900" -activecolor "#0000ff" -inactivecolor "#00cc99" -freecolor "#ffffcc" -swapcolor red -nolabel -jumpscroll 10 -geometry 520x310-1602+2 &

xsetbg /home/che/X11/rainlight.gif
xmodmap /home/che/X11/xmodmap/xmodmap 
xrdb /home/che/.Xdefaults 

[ -x /usr/bin/urxvt ] || uxterm &

xscreensaver -no-capture-stderr -no-splash &

echo ----- $$
echo $$ > /home/che/X11/Xpid/pid
echo ----- $$

fvwm
