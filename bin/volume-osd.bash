#! /bin/bash

# Change PCM volume with amixer and show the new level on screen.
# Usage: volume-osd.bash 1db+|1db-|toggle

amixer -q -c 0 set PCM "$1"

level=$(amixer -c 0 get PCM | sed -n 's/.*Front Left:.*\[\([0-9]*\)%\].*/\1/p')

# xosd's own bar spans the whole X screen (all monitors), so draw the
# bar as text and center it on the secondary (non-primary) monitor instead.
width=40
filled=$(( level * width / 100 ))
bar=$(printf '%*s' "$filled" '' | tr ' ' '#')$(printf '%*s' $(( width - filled )) '' | tr ' ' '.')

read -r mon_w mon_x < <(xrandr --listmonitors |
	sed -n 's/.* +[^* ][^ ]* \([0-9]*\)\/[0-9]*x[0-9]*\/[0-9]*+\([0-9]*\)+.*/\1 \2/p')
font='-adobe-courier-bold-r-normal--40-*-75-75-m-240-iso8859-1'
charw=24
indent=$(( ${mon_x:-0} + (${mon_w:-1920} - width * charw) / 2 ))

# Remove the previous indicator so repeated key presses don't stack up.
pkill -u "$USER" -f '^osd_cat .*--font=-adobe-courier-bold-r-normal--40' 2>/dev/null

printf 'Volym %d%%\n%s\n' "$level" "$bar" |
	osd_cat --lines=2 --pos=bottom --align=left --indent="$indent" \
		--offset=80 --delay=1 \
		--font="$font" \
		--colour='#206020' --outline=2 --outlinecolour='#d0ffe0' &
