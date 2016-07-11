bashrc_sourced=y

[ -r ~/.functions -a ! "$os" ] && . ~/.functions

if tty -s; then
    echo sourcing .bashrc

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
    shopt -s failglob     # Don't expand * to '*' if no matches.
    shopt -u sourcepath   # Don't use PATH for sourcing files.
    shopt -u progcomp     # Don't use programmable completion.

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

fi
