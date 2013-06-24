[ -f ~/.bashrc ] && . ~/.bashrc;

PATH=`setpath ~/bin ~/perl /usr/local/adm/bin /bin /usr/bin /sbin /usr/sbin ${PATH//:/ } \
      /usr/local/bin /opt/cfengine/cfe/sbin /opt/cfengine/cfe/bin /opt/samba/bin /usr/openv/netbackup/bin \
      /opt/rational/clearcase/bin /opt/rational/common/bin /opt/rational/clearcase/etc`
MANPATH=`setpath /usr/local/adm/man ${MANPATH//:/ } /opt/umtool/man /opt/cfengine/cfe/man`
export PERL5LIB=`setpath ${PERL5LIB//:/ } ~/perllib`

export LANG=sv_SE.utf8
export LC_MESSAGES=C
[ $os = CY ] && LANG=sv_SE.ISO-8859-1
[ $os = HP ] && LANG=sv_SE.iso88591
[ $host = lx310020 ] && LANG=sv_SE.iso88591
[ $host = lx310021 ] && LANG=sv_SE.iso88591

export PAGER='less -idQMXsr'
export MANPAGER='less -sC'
export LESS=idQMX

export GZIP='--best'
export EDITOR=vi
export CHESSDIR=~/chess

# Find a working terminal-type, and start with current $TERM
if tty -s; then
    for term in $TERM rxvt-unicode rxvt xterm vt100; do
	if tput -T $term cols >/dev/null 2>&1; then
	    TERM=$term;
	    break;
	fi
    done
fi

umask 02

[ $domain = utv.rps.police.se ] && export LDAP_BASEDN='dc=utv,dc=rps,dc=police,dc=se';
