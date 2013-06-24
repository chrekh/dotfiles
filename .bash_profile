[ -f ~/.bashrc ] && . ~/.bashrc;

PATH=`setpath ~/bin ~/perl /usr/local/adm/bin ${PATH//:/ } /usr/local/bin`
MANPATH=`setpath /usr/local/adm/man ${MANPATH//:/ }`

export LANG=sv_SE.utf8
export LC_MESSAGES=C

export PAGER='less -idQMXsr'
export LESS=idQMX
#unset  LESSOPEN

export GZIP='--best'
export EDITOR=vi
export CHESSDIR=~/chess
