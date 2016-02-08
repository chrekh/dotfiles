tty -s && echo sourcing .bash_profile
[ -r ~/.functions -a ! "$os" ] && . ~/.functions
PATH=$(setpath ~/bin ~/perl /usr/local/adm/bin /usr/local/um/bin /usr/local/bin \
    /opt/puppet/bin/ /opt/puppetlabs/bin \
    /bin /usr/bin /sbin /usr/sbin \
    ${PATH//:/ } \
    /opt/boksm/bin /opt/boksm/sbin \
    /opt/cfengine/cfe/sbin /opt/cfengine/cfe/bin /opt/samba/bin /usr/openv/netbackup/bin \
    /opt/rational/clearcase/bin /opt/rational/common/bin /opt/rational/clearcase/etc
)
MANPATH=$(manpath 2>/dev/null)
MANPATH=$(setpath /usr/local/adm/man /usr/local/um/man /opt/puppet/share/ma1n \
    ${MANPATH//:/ } \
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

umask 022

[ $domain = utv.rps.police.se ] && export LDAP_BASEDN='dc=utv,dc=rps,dc=police,dc=se';
[ $domain = utv.polisen.se ] && export LDAP_BASEDN='dc=utv,dc=polisen,dc=se';

# Git configurations depending on where I am
export GIT_AUTHOR_EMAIL=che@chrekh.se
export GIT_AUTHOR_NAME='Christer Ekholm'
case $domain in
    *.polisen.se | *.police.se)
	GIT_AUTHOR_EMAIL=Christer.Ekholm@polisen.se
	;;
    *.init.se)
	GIT_AUTHOR_EMAIL=che@init.se
	;;
esac
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME

# I don't want man to ask stuipd questions
[ $dist = suse ] && export MAN_POSIXLY_CORRECT=1

# Set terminal title to my prefered name for this host
if [ -e ~/.hostname ] && title=$(grep ^$host ~/.hostname); then
    title="$title ($dist)"
    echo $(tput tsl)${title}$(tput fsl)
elif [ -n "$WINDOWID" ] && title=$(xprop -id $WINDOWID -notype WM_NAME \
			           | sed -e 's/^.*\" *\(.*\) *\"/\1/'); then
    title="$title ($dist)"
    echo $(tput tsl)${title}$(tput fsl)
fi

ssh-add -l > /dev/null 2>&1
# 2 means ssh-add is unable to contact the authentication agent.
if [ $? = 2 ]; then
    if [ -n "$SSH_AUTH_SOCK" ] && [ -r $SSH_AUTH_SOCK ] && [ -n "$SSH_AGENT_PID" ]; then
	if kill -0 $SSH_AGENT_PID >/dev/null 2>&1; then
	    break;
	fi
    fi
    echo "Start a new ssh-agent"
    eval $(ssh-agent)
fi
