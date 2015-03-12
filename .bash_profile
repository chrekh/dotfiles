tty -s && echo sourcing .bash_profile
[ -r ~/.functions -a ! "$os" ] && . ~/.functions
PATH=$(setpath ~/bin ~/perl /usr/local/adm/bin /opt/puppet/bin/ /bin /usr/bin /sbin /usr/sbin \
    ${PATH//:/ } \
    /opt/boksm/bin /opt/boksm/sbin \
    /usr/local/bin /opt/cfengine/cfe/sbin /opt/cfengine/cfe/bin /opt/samba/bin /usr/openv/netbackup/bin \
    /opt/rational/clearcase/bin /opt/rational/common/bin /opt/rational/clearcase/etc
)
MANPATH=$(manpath 2>/dev/null)
MANPATH=$(setpath /usr/local/adm/man /opt/puppet/share/man ${MANPATH//:/ } \
    /opt/boksm/man \
    /opt/umtool/man /opt/cfengine/cfe/man
)
export PERL5LIB=$(setpath ${PERL5LIB//:/ } ~/perllib)
[ -f ~/.bashrc -a ! "$bashrc_sourced" ] && . ~/.bashrc;

export LANG=sv_SE.utf8
export LC_MESSAGES=C
[ $os = CY ] && LANG=sv_SE.ISO-8859-1
[ $os = HP ] && LANG=sv_SE.iso88591
[ $os = Da ] && LANG=sv_SE.UTF-8
[ $host = lx310020 ] && LANG=sv_SE.iso88591
[ $host = lx310021 ] && LANG=sv_SE.iso88591

export PAGER='less -idQMXsR'
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
[ $domain = utv.polisen.se ] && export LDAP_BASEDN='dc=utv,dc=polisen,dc=se';

# Create the right .gitconfig depending on where I am. But do that only once
if [ ! -e ~/.gitconfig ]; then
    [ $domain = utv.rps.police.se ] && cat ~/.gitconfig-rps > ~/.gitconfig
    [ $domain = utv.polisen.se ] && cat ~/.gitconfig-rps > ~/.gitconfig
    [ $domain = chrekh.se ]    && cat ~/.gitconfig-home > ~/.gitconfig
    [ $domain = init.se ]    && cat ~/.gitconfig-init > ~/.gitconfig
    cat ~/.gitaliases >> ~/.gitconfig
fi

# If the homedirectory controlled by git, update it.
if tty -s && [ -f ~/.git/config ] && git --version > /dev/null 2>&1 ; then
    ( cd && git pull )
fi

# I don't want man to ask stuipd questions
[ $dist = suse ] && export MAN_POSIXLY_CORRECT=1

# Set terminal title to my prefered name for this host
if [ -e ~/.hostname ]; then
    title=$(grep ^$host .hostname | sed -e "s/^$host *//")
    [ -z "$title" ] || echo $(tput tsl) $title $(tput fsl)
fi
