bashrc_sourced=y


[ -r ~/.functions -a ! "$os" ] && . ~/.functions
[ -r /home/196603089076/.functions -a ! "$os" ] && .  /home/196603089076/.functions

if tty -s; then
    echo sourcing .bashrc

    # Use my keymap in polisen PROD
    if [ $domain = appl.polisen.se -o $domain = dc.polisen.se -o $domain = dmz.polisen.se \
	-o $domain = mgmt.polisen.se -o $domain = rps.police.se -o $host = NT330595 ]; then
	# Set HOME to my home if BoKS has set it to /root
	if [ "$PWD" = /root -a $HOME = /root ]; then
	    HOME=/home/196603089076
	fi
	if type vim > /dev/null 2>&1; then
	    alias vi='vim -u ~/.vimrc-polisen-prod'
	else
	    alias vi='vi -u ~/.vimrc-polisen-prod'
	fi
	bind -f ~/.keymap-polisen-prod
    fi

    # prompt
    PROMPT_DIRTRIM=5
    PS1='\[\e[28;1m\]\t \h:\w \$\[\e[0m\] '
    if [ -r ~/bin/git-prompt.sh ]; then
	GIT_PS1_SHOWUPSTREAM="auto"
	GIT_PS1_SHOWDIRTYSTATE=1
	. ~/bin/git-prompt.sh
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
    [ -f ~/.bash_history ] && rm -f ~/.bash_history
    [ -d ~/.bash_history ] || mkdir ~/.bash_history
    HISTFILE=~/.bash_history/$host$(tty | sed -e s:/:_:g)
    HISTSIZE=200

    [ -r ~/.aliases ] && . ~/.aliases

    stty kill ^@
    case $TERM in
	vt* | xterm | linux)
	    stty erase '^?'
	    ;;
	*)
	    stty erase '^h'
    esac

    if [ "$PWD" = /root -a $HOME = /root ]; then
	HOME=/home/196603089076
    fi
fi
