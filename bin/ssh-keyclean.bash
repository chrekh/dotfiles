#! /bin/bash

declare -A entries

for h in "$@"; do
  entries["$h"]=1
  
  while read -r line; do
    declare -a words
    read -r -a words <<< "$line"
    if [[ ${words[3]} == alias ]]; then
      entries["${words[0]}"]=1
    elif [[ ${words[2]} == address || ${words[3]} == address ]]; then
      entries["${words[0]}"]=1
      entries["${words[-1]}"]=1
    fi
  done < <(/usr/bin/host "$h")
done

for entry in "${!entries[@]}"; do
  ssh-keygen -R "$entry"
done
