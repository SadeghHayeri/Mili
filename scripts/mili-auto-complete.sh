#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:"

case $OSTYPE in
  darwin*)
    CONFIG=$(cat "/Users/<-USER->/.mili/config.json");;
  linux*)
    CONFIG=$(cat "/home/<-USER->/.mili/config.json");;
  *)
    echo "Mili does not support your OS yet, sorry :("
esac

_mili_auto_complete() {
  local cur prev

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=( $(compgen -W "login status logout" -- $cur) )
  elif [ $COMP_CWORD -eq 2 ]; then
    if [[ "$prev" == "login" ]]; then
      USERS=$(echo $CONFIG | jq '.login_information' | jq -r '.[].username')
      COMPREPLY=( $(compgen -W "$USERS" -- $cur) )
    fi
  fi

  return 0
}

complete -F _mili_auto_complete mili
