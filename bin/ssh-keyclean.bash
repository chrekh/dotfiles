#! /bin/bash

h=$1
[[ $h ]] || exit 1

declare -A entries
entries["$h"]=1

IFS='
'
for line in $(/usr/bin/host "$h"); do
  declare -a words
  IFS=" " read -r -a words <<< "$line"
  if [[ ${words[3]} == alias ]]; then
    entries["${words[0]}"]=1
  elif [[ ${words[2]} == address || ${words[3]} == address ]]; then
    entries["${words[0]}"]=1
    entries["${words[-1]}"]=1
  fi
done

for entry in "${!entries[@]}"; do
  ssh-keygen -R "$entry"
done
