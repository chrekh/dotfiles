# prompt

PS1='\[\e[28;1m\]\t \h:\w \$\[\e[0m\]'

set -b
set -h
set -m
set +H


HISTCONTROL=ignoreboth
HISTFILE=~/.../bash_history
HISTSIZE=200
FIGNORE=~

. ~/.aliases

if tty -s; then
    stty kill ^@
    if [ "$TERM" = "xterm" ]; then
	stty erase ^?
    fi
    test -r ~/.functions && . ~/.functions
fi

# Completion directives
#complete -A command time
#complete -A command sudo
#complete -A command man

