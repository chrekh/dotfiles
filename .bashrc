# shellcheck shell=bash
# shellcheck source=./.functions
# Source global definitions
for rc in /etc/bash/bashrc /etc/bashrc; do
    if [[ -f $rc ]]; then
        . $rc
        break
    fi
done
# /etc/profile.d/vte.sh uses PROMPT_COMMAND to change window title, disabling
# my chosen title.
unset PROMPT_COMMAND

if [[ -n "$SUDO_USER" ]]; then
    home_candidate=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    home_candidate=${HOME:=~}
fi
if [[ -r ${home_candidate}/.functions ]]; then
    my_real_home=${home_candidate}
elif [[ -r /home/u0043002/.functions ]]; then
    my_real_home=/home/u0043002
elif [[ -r /home/jjri/.functions ]]; then
    my_real_home=/home/jjri
fi

if [[ -d /home/196603089076 ]]; then
    echo "Warning! /home/196603089076 exists!" >&2
fi

[[ "$os" ]] || . $my_real_home/.functions

PATH=$(setpath ~/${site}/bin ~/bin ~/perl ~/.perl6/bin /usr/local/adm/bin /usr/local/bin \
    /opt/boksm/bin /opt/boksm/sbin \
    '/c/Program Files (x86)/HelpSystems/BoKS SSH Client' \
    '/c/Program Files (x86)/Fox Technologies/BoKS SSH Client' \
    /bin /usr/bin /sbin /usr/sbin \
    /e/bokshack \
    ${PATH//:/ } \
    /opt/puppetlabs/bin /opt/puppetlabs/puppet/bin \
    /opt/boksm/lib /usr/share/perl6/site/bin \
    /usr/lib/mit/bin \
    /opt/cmcluster/bin \
    /opt/cfengine/cfe/sbin /opt/cfengine/cfe/bin /opt/samba/bin /usr/openv/netbackup/bin \
    /opt/rational/clearcase/bin /opt/rational/common/bin /opt/rational/clearcase/etc
)
MANPATH=$(manpath 2>/dev/null)
# shellcheck disable=SC2086
MANPATH=$(setpath /usr/local/adm/man /opt/puppet/share/ma1n \
    /usr/local/man /usr/local/share/man \
    ${MANPATH//:/ } \
    /opt/boksm/man \
    /opt/umtool/man /opt/cfengine/cfe/man
)

if [[ "$dist" == "RedHat" ]]; then
    [[ "$sclsetup" ]] || . $my_real_home/.sclsetup
fi

if tty -s; then
    echo sourcing .bashrc

    # Use my keymap in polisen PROD
    if [[ $domain = appl.polisen.se || $domain = dc.polisen.se || $domain = dmz.polisen.se \
        || $domain = pki.polisen.se || $domain = exkop.polisen.se || $domain = doris.polisen.se \
        || $domain = mgmt.polisen.se || $domain = rps.police.se || $domain = bd.polisen.se \
        || $domain = umad.utv.polisen.se \
        || $host = NT330595 || $host = NT462792 ]]; then
        if [[ -r $my_real_home/.keymap-iso646 ]]; then
          bind -f $my_real_home/.keymap-iso646
          alias unswe="bind -f $my_real_home/.keymap-iso646"
          swe() {
            for c in å ä ö Å Ä Ö; do
              bind -r "$c"
            done
          }
        fi
    fi

    # prompt
    [[ $host == lx586038 ]] && hinfo='(BoKS/GAP)'
    [[ $host == lx413899 && $domain == utv.polisen.se ]] && hinfo='(homer)'
    [[ $host =~ ^boks[rm] && $domain == pki.polisen.se ]] && hinfo='(PROD)'
    [[ $domain == dmz.polisen.se ]] && hinfo='(DMZ)'
    [[ $domain == exkop.polisen.se ]] && hinfo='(EXKOP)'
    PROMPT_DIRTRIM=5
    PS1='\[\e[28;1m\]\t \h'"$hinfo"':\w \$\[\e[0m\] '
    if [[ -r $my_real_home/contrib/completion/git-prompt.sh ]]; then
        # shellcheck disable=SC2034
        GIT_PS1_SHOWUPSTREAM="auto"
        # shellcheck disable=SC2034
        GIT_PS1_SHOWDIRTYSTATE=1
        . $my_real_home/contrib/completion/git-prompt.sh
        PS1='\[\e[28;1m\]\t \h'"$hinfo"':\w$(__git_ps1) \$\[\e[0m\] '
    fi

    set -m # enable job controll
    set -b # print exit status immeitately
    set +H # Disable ! history substitution (I never use them)

    shopt -s checkwinsize # check window size after each command
    shopt -s failglob     # Don't expand * to '*' if no matches.
    shopt -u sourcepath   # Don't use PATH for sourcing files.
    shopt -u progcomp     # Don't use programmable completion.

    HISTCONTROL=ignoredups
    if [[ "$uid" -ne 0 ]]; then
        HISTTIMEFORMAT="%y-%m-%d %H:%M:%S "
        [[ -d $my_real_home/.historydir ]] && HISTFILE=$my_real_home/.historydir/$host
        [[ -d $my_real_home/.bash_history ]] && rm -rf $my_real_home/.bash_history
    fi
    HISTSIZE=200

    [[ -r $my_real_home/.aliases ]] && . $my_real_home/.aliases

    stty kill ^@
    case $TERM in
        vt* | xterm | xterm-* | linux)
            stty erase '^?'
            ;;
        *)
            stty erase '^h'
    esac
fi
