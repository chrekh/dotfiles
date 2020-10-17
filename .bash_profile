# shellcheck shell=bash
# shellcheck source=./.functions
tty -s && echo sourcing .bash_profile
[[ -r ~/.functions && ! "$os" ]] && . ~/.functions
PATH=$(setpath ~/${site}/bin ~/bin ~/perl ~/.perl6/bin /usr/local/adm/bin /usr/local/bin \
    /opt/puppet/bin/ /opt/puppetlabs/bin \
    /opt/boksm/bin /opt/boksm/sbin '/c/Program Files (x86)/Fox Technologies/BoKS SSH Client' \
    /bin /usr/bin /sbin /usr/sbin \
    /e/bokshack \
    ${PATH//:/ } \
    /usr/share/perl6/site/bin \
    /usr/lib/mit/bin \
    /opt/cfengine/cfe/sbin /opt/cfengine/cfe/bin /opt/samba/bin /usr/openv/netbackup/bin \
    /opt/rational/clearcase/bin /opt/rational/common/bin /opt/rational/clearcase/etc
)
MANPATH=$(manpath 2>/dev/null)
MANPATH=$(setpath /usr/local/adm/man /opt/puppet/share/ma1n \
    /usr/local/man /usr/local/share/man \
    ${MANPATH//:/ } \
    /opt/boksm/man \
    /opt/umtool/man /opt/cfengine/cfe/man
)
export PERL5LIB=$(setpath ${PERL5LIB//:/ } ~/perllib)
[ -f ~/.bashrc ] && . ~/.bashrc;

export LANG=sv_SE.utf8
[ $os = CY ] && LANG=sv_SE.ISO-8859-1
[ $os = HP ] && LANG=sv_SE.iso88591
[ $os = Da -o $os = Fr ] && LANG=sv_SE.UTF-8
[ $host = lx310020 ] && LANG=sv_SE.iso88591
[ $host = lx310021 ] && LANG=sv_SE.iso88591
export LC_CTYPE=$LANG
export LC_MESSAGES=C

export PAGER='less -idQMXsR'
export LESS=idQMX

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
    *.rsv.se | rsv.se | *.rsvm.se | rsvm.se | *.skatteverket.se )
	GIT_AUTHOR_EMAIL=Christer.Ekholm@skatteverket.se
	;;
    *init.se)
	GIT_AUTHOR_EMAIL=che@init.se
	;;
esac
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
[ $os = MI ] && type blink > /dev/null 2>&1 && export GIT_SSH=blink

# I don't want man to ask stuipd questions
[ $dist = Suse ] && export MAN_POSIXLY_CORRECT=1

# Set terminal title to my prefered name for this host
[ -n "$dist" ] && title="[$dist]"
[ -n "$rel" ] && title="[$dist $rel]"
if [[ -e /etc/hostaliases && -s /etc/hostaliases ]]; then
    aliases=`cat /etc/hostaliases`
    printf "\033]2;%s\007\033]1;%s\007" "$host $title ($aliases)"
elif [ -n "$WINDOWID" ] && $(hash xprop > /dev/null 2>&1) && title=$(xprop -id $WINDOWID -notype WM_NAME \
			           | sed -e 's/^.*\" *\(.*\) *\"/\1/'); then
    echo $(tput tsl)${title}$(tput fsl)
fi

if tty -s; then
    # Reuse or start new ssh-agent
    ssh-add -l > /dev/null 2>&1
    if [ $? -eq 2 ]; then
	# ssh-add is unable to contact the agent.
	if [ -n "$SSH_AGENT_PID" ] && ps --no-headers -p $SSH_AGENT_PID >/dev/null 2>&1; then
	    # Kill it.
	    eval $(ssh-agent -k)
	    unset SSH_AUTH_SOCK
	fi
	# Read stored agent info.
	[ -e ~/.ssh-agent ] && . ~/.ssh-agent
	ssh-add -l > /dev/null 2>&1
	if [ $? -eq 2 ]; then
	    # ssh-add is still unable to contact the agent.
	    if [ -n "$SSH_AGENT_PID" ] && ps --no-headers -p $SSH_AGENT_PID >/dev/null 2>&1; then
		# Kill it.
		eval $(ssh-agent -k)
		unset SSH_AUTH_SOCK
	    fi
	    echo "Start a new ssh-agent"
	    eval $(ssh-agent)
	    # Store the agent info for later shells to use.
	    > ~/.ssh-agent
	    if [ -n "$SSH_AUTH_SOCK" -a -r "$SSH_AUTH_SOCK" ]; then
		echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.ssh-agent
	    fi
	    if [ -n "$SSH_AGENT_PID" ] && ps --no-headers -p $SSH_AGENT_PID >/dev/null 2>&1; then
		echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ~/.ssh-agent
	    fi
	else
	    # ssh-add is able to contact the agent from stored info.
	    if [ -n "$SSH_AGENT_PID" ] && ps --no-headers -p $SSH_AGENT_PID >/dev/null 2>&1; then
		echo "Use existing ssh-agent ($SSH_AGENT_PID)"
	    elif [[ -n "$SSH_AUTH_SOCK" && -r "$SSH_AUTH_SOCK" ]]; then
		echo "Use forwarded ssh-agent"
	    fi
	fi
    else
	# ssh-add is able to contact the agent from current env.
	if [ -n "$SSH_AGENT_PID" ] && ps --no-headers -p $SSH_AGENT_PID >/dev/null 2>&1; then
	    echo "Use existing ssh-agent ($SSH_AGENT_PID)"
	elif [[ -n "$SSH_AUTH_SOCK" && -r "$SSH_AUTH_SOCK" ]]; then
	    echo "Use forwarded ssh-agent"
	fi
    fi
fi
