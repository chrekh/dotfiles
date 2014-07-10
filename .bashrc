bashrc_sourced=y
[ -r ~/.functions -a ! "$os" ] && . ~/.functions
[ -r ~/.git-prompt.sh ] && . ~/.git-prompt.sh

if tty -s; then
    echo sourcing .bashrc

    # prompt
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWDIRTYSTATE=1
    PS1='\[\e[28;1m\]\t \h:\w$(__git_ps1) \$\[\e[0m\]'
    PROMPT_DIRTRIM=5
    
    set -b
    set -m
    set +H

    shopt -s checkwinsize

    HISTCONTROL=ignoredups
    [ -f ~/.bash_history ] && rm -f ~/.bash_history
    [ -d ~/.bash_history ] || mkdir ~/.bash_history
    HISTFILE=~/.bash_history/$host$(tty | sed -e s:/:_:g)
    HISTSIZE=200

    [ -r ~/.aliases ] && . ~/.aliases

    stty kill ^@
    case $TERM in
	vt* | xterm | linux)
	    stty erase ^?
	    ;;
	*)
	    stty erase ^h
    esac

fi
