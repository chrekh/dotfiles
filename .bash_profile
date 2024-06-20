# xshellcheck shell=bash
# xshellcheck source=./.functions
# Ensure i start at home
cd
tty -s && echo sourcing .bash_profile
[[ -r ~/.functions && ! "$os" ]] && . ~/.functions
# shellcheck disable=SC2086
# shellcheck disable=SC2086
PERL5LIB=$(setpath ${PERL5LIB//:/ } ~/perllib)
export PERL5LIB
[[ -f ~/.bashrc ]] && . ~/.bashrc;

export LANG=sv_SE.utf8
[[ $os = CY ]] && LANG=sv_SE.ISO-8859-1
[[ $os = HP ]] && LANG=sv_SE.iso88591
[[ $os = Da || $os = Fr ]] && LANG=sv_SE.UTF-8
[[ $host = lx310020 ]] && LANG=sv_SE.iso88591
[[ $host = lx310021 ]] && LANG=sv_SE.iso88591
export LC_CTYPE=$LANG
export LC_MESSAGES=C

export PAGER='less -idQMXsR'
export LESS=idQMX

export EDITOR=vi
if ! hash vi > /dev/null 2>&1; then
  hash vim > /dev/null 2>&1 && EDITOR=vim
fi
export CHESSDIR=~/chess

export BOKSRULE_DEFAULT_FIELDS=id,u,c,method,source,destination,program,target-user,file
export LVM_SUPPRESS_FD_WARNINGS=1

unset LS_COLORS

export SYSTEMD_COLORS=false

# Find a working terminal-type, and start with current $TERM
if tty -s; then
  for term in $TERM rxvt-unicode rxvt xterm vt100; do
    if tput -T "$term" cols >/dev/null 2>&1; then
      TERM=$term;
      break;
    fi
  done
fi

umask 022

[[ $domain = utv.rps.police.se ]] && export LDAP_BASEDN='dc=utv,dc=rps,dc=police,dc=se';
[[ $domain = utv.polisen.se ]] && export LDAP_BASEDN='dc=utv,dc=polisen,dc=se';

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

# I don't want man to ask stuipd questions
[[ $dist = Suse ]] && export MAN_POSIXLY_CORRECT=1

# Set terminal title to my prefered name for this host
[[ -n "$dist" ]] && title="$host [$dist]"
[[ -n "$rel" ]] && title="$host [$dist $rel]"
if [[ -e ~/db/aliases.bash && ${BASH_VERSINFO[0]} -ge 4 ]]; then
  . ~/db/aliases.bash
  if [[ -n ${hostaliases[$HOST]} ]]; then
    title+=' ('${hostaliases[$HOST]}')'
  fi
fi
echo -n "]0;${title}" 

if tty -s; then
  # Reuse or start new ssh-agent
  ssh-add -l > /dev/null 2>&1
  if [[ $? -eq 2 ]]; then
    # ssh-add is unable to contact the agent.
    if [[ -n "$SSH_AGENT_PID" ]] && ps --no-headers -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
      # Kill it.
      eval "$(ssh-agent -k)"
      unset SSH_AUTH_SOCK
    fi
    # Read stored agent info.
    [[ -e ~/.ssh-agent ]] && . ~/.ssh-agent
    ssh-add -l > /dev/null 2>&1
    if [[ $? -eq 2 ]]; then
      # ssh-add is still unable to contact the agent.
      if [[ -n "$SSH_AGENT_PID" ]] && ps --no-headers -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
        # Kill it.
        eval "$(ssh-agent -k)"
        unset SSH_AUTH_SOCK
      fi
      echo "Start a new ssh-agent"
      eval "$(ssh-agent)"
      # Store the agent info for later shells to use.
      : > ~/.ssh-agent
      if [[ -n "$SSH_AUTH_SOCK" && -r "$SSH_AUTH_SOCK" ]]; then
        echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.ssh-agent
      fi
      if [[ -n "$SSH_AGENT_PID" ]] && ps --no-headers -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
        echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ~/.ssh-agent
      fi
    else
      # ssh-add is able to contact the agent from stored info.
      if [[ -n "$SSH_AGENT_PID" ]] && ps --no-headers -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
        echo "Use existing ssh-agent ($SSH_AGENT_PID)"
      elif [[ -n "$SSH_AUTH_SOCK" && -r "$SSH_AUTH_SOCK" ]]; then
        echo "Use forwarded ssh-agent"
      fi
    fi
  else
    # ssh-add is able to contact the agent from current env.
    if [[ -n "$SSH_AGENT_PID" ]] && ps --no-headers -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
      echo "Use existing ssh-agent ($SSH_AGENT_PID)"
    elif [[ -n "$SSH_AUTH_SOCK" && -r "$SSH_AUTH_SOCK" ]]; then
      echo "Use forwarded ssh-agent"
    fi
  fi
fi

if tty -s; then
  uname -s
  if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    # bash-4 have hashes
    if hash facter > /dev/null 2>&1; then
      declare -A info
      while read -r line; do
        for key in family major name id; do
          re="^${key}"' => "([^"]+)'
          if [[ $line =~ $re ]]; then
            info[$key]="${BASH_REMATCH[1]}"
          fi
        done
      done < <(facter os)
      echo "${info[family]}-${info[major]} ${info[name]} ${info[id]}"
    fi
  fi
fi
