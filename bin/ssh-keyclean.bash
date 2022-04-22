#! /bin/bash

h=$1
[[ $h ]] || exit 1

declare -a entries
entries=($(host "$h"))

ssh-keygen -R "$h"

if [[ "${entries[1]}" == has ]]; then
  ssh-keygen -R "${entries[0]}"
  ssh-keygen -R  "${entries[-1]}"
fi
