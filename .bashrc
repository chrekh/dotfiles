host=`hostname`

if tty -s; then

    # prompt
    PS1='\[\e[28;1m\]\t \h:\w \$\[\e[0m\]'
    PROMPT_DIRTRIM=5
    
    set -b
    set -m
    set +H


    HISTCONTROL=ignoredups
    HISTFILE=~/.bash_history/`uname -n``tty | sed -e s:/:_:g`
    HISTSIZE=200

    test -r ~/.aliases && . ~/.aliases
    test -r ~/.functions && . ~/.functions

    stty kill ^@
    if [ "$TERM" = "xterm" ]; then
	stty erase ^?
    fi

    # Completion directives
    complete -A command sudo

fi
