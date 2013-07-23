#! /bin/sh

exec >$HOME/.xsessionlog 2>$HOME/.xsessionlog
#sleep 5
ssh-add -l
/usr/X11/bin/xauth list
#sleep 5

test -r $HOME/.profile && . $HOME/.profile

echo IN'  '`date +"V-%V %c"` >> $HOME/log/xloginlog

unset common_profile_is_sourced
#eval `ssh-agent`
#xterm &

# xterm behöher ha rätt LANG för att åäö skall funka.
LANG=sv_SE.iso88591
export LANG
xterm -geometry 110x40+2-2 -ls -title wiggum &

xset b off
xrdb -load $HOME/.Xdefaults

xmodmap $HOME/X11/xmodmap/xming

#xsetroot -solid "#703000"
xsetroot -solid "#c000e0"

# Programs
host=`hostname`
#nice -n 19 xclock -digital -geometry -20+20 -fs '-*-bitstream charter-bold-r-*-*-30-*-*-*-*-*-*-*' -update 1 &
set -x
nice -n 19 xload -jumpscroll 10 -update 2 -geometry 380x100-10+80 &


for wm in /usr/X11*/bin/fvwm /usr/X11*/bin/fvwm2 /usr/bin/X11/mwm /usr/bin/X11/hpwm; do
    if [ -x $wm ]; then
        $wm;
        break;
    fi
done


#ssh-agent -k
#

echo OUT' '`date +"V-%V %c"` >> $HOME/log/xloginlog
