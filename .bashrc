[ -r ~/.functions ] && . ~/.functions

if tty -s; then

    # prompt
    PS1='\[\e[28;1m\]\t \h:\w \$\[\e[0m\]'
    PROMPT_DIRTRIM=5
    
    set -b
    set -m
    set +H

    shopt -s checkwinsize

    HISTCONTROL=ignoredups
    HISTFILE=~/.bash_history/$host$(tty | sed -e s:/:_:g)
    HISTSIZE=200

    [ -r ~/.aliases ] && . ~/.aliases

    stty kill ^@
    case $TERM in
	vt* | xterm)
	    stty erase ^?
	    ;;
	*)
	    stty erase ^h
    esac

    # Completion directives
    complete -A command -A file sudo
fi
