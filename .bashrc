# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

if [ -n "$SUDO_USER" ]; then
    home_candidate=$(getent passwd $SUDO_USER | cut -d: -f6)
else
    home_candidate=${HOME:=~}
fi
if [ -r ${home_candidate}/.functions ]; then
    my_real_home=${home_candidate}
elif [ -r /home/196603089076/.functions ]; then
    my_real_home=/home/196603089076/
elif [ -r /home/u0043002/.functions ]; then
    my_real_home=/home/u0043002
elif [ -r /home/jjri/.functions ]; then
    my_real_home=/home/jjri
fi
[ "$os" ] || . $my_real_home/.functions
if tty -s; then
    echo sourcing .bashrc

    # Use my keymap in polisen PROD
    if [ $domain = appl.polisen.se -o $domain = dc.polisen.se -o $domain = dmz.polisen.se \
	-o $domain = mgmt.polisen.se -o $domain = rps.police.se -o $domain = bd.polisen.se \
	-o $host = NT330595 -o $host = NT462792 ]; then
	# Set HOME to my home if BoKS has set it to /root
	if [ "$PWD" = /root -a $HOME = /root ]; then
	    HOME=/home/196603089076
	fi
	bind -f ~/.keymap-polisen-prod
    fi

    # prompt
    PROMPT_DIRTRIM=5
    PS1='\[\e[28;1m\]\t \h:\w \$\[\e[0m\] '
    if [ -r $my_real_home/contrib/completion/git-prompt.sh ]; then
	GIT_PS1_SHOWUPSTREAM="auto"
	GIT_PS1_SHOWDIRTYSTATE=1
	. $my_real_home/contrib/completion/git-prompt.sh
	PS1='\[\e[28;1m\]\t \h:\w$(__git_ps1) \$\[\e[0m\] '
    fi

    set -m # enable job controll
    set -b # print exit status immeitately
    set +H # Disable ! history substitution (I never use them)

    shopt -s checkwinsize # check window size after each command
    shopt -s failglob	  # Don't expand * to '*' if no matches.
    shopt -u sourcepath	  # Don't use PATH for sourcing files.
    shopt -u progcomp	  # Don't use programmable completion.

    HISTCONTROL=ignoredups
    if [ "$uid" -ne 0 ]; then
	HISTTIMEFORMAT="%y-%m-%d %H:%M:%S "
	[ -d $my_real_home/.bash_history ] && rm -rf $my_real_home/.bash_history
    fi
    HISTSIZE=200

    [ -r $my_real_home/.aliases ] && . $my_real_home/.aliases

    stty kill ^@
    case $TERM in
	vt* | xterm | xterm-* | linux)
	    stty erase '^?'
	    ;;
	*)
	    stty erase '^h'
    esac

    if [ "$PWD" = /root -a $HOME = /root ]; then
	HOME=/home/196603089076
    fi
fi
