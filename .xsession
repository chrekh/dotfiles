#! /bin/sh

exec >$HOME/.xsessionlog 2>$HOME/.xsessionlog
#sleep 5
ssh-add -l
xauth list
#sleep 5

test -r $HOME/.bash_profile && . $HOME/.bash_profile

echo IN'  '`date +"V-%V %c"` >> $HOME/log/xloginlog

xset b off
xrdb -load $HOME/.Xdefaults

xmodmap $HOME/X11/xmodmap/pc

#xsetroot -solid "#703000"
xsetbg $HOME/X11/rainlight.gif

fvwm

#ssh-agent -k
#

echo OUT' '`date +"V-%V %c"` >> $HOME/log/xloginlog
