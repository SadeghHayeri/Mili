#!/bin/bash

# banner!
echo "
                     [0;1;34;94m▄[0;1;35;95m▄▄[0m  [0;1;33;93m▄▄[0;1;32;92m▄[0m     [0;1;35;95m██[0m     [0;1;32;92m▄[0;1;36;96m▄▄[0;1;34;94m▄[0m         [0;1;36;96m██[0m
                     [0;1;35;95m█[0;1;31;91m██[0m  [0;1;32;92m██[0;1;36;96m█[0m     [0;1;31;91m▀▀[0m     [0;1;36;96m▀[0;1;34;94m▀█[0;1;35;95m█[0m         [0;1;34;94m▀▀[0m
              [0;1;36;96m▄▄[0m     [0;1;31;91m█[0;1;33;93m██[0;1;32;92m██[0;1;36;96m██[0;1;34;94m█[0m   [0;1;31;91m██[0;1;33;93m██[0m       [0;1;35;95m█[0;1;31;91m█[0m       [0;1;34;94m██[0;1;35;95m██[0m        [0;1;34;94m▄▄[0m
              [0;1;34;94m██[0m     [0;1;33;93m█[0;1;32;92m█[0m [0;1;36;96m██[0m [0;1;34;94m█[0;1;35;95m█[0m     [0;1;32;92m██[0m       [0;1;31;91m█[0;1;33;93m█[0m         [0;1;31;91m██[0m        [0;1;35;95m██[0m
                     [0;1;32;92m█[0;1;36;96m█[0m [0;1;34;94m▀▀[0m [0;1;35;95m█[0;1;31;91m█[0m     [0;1;36;96m██[0m       [0;1;33;93m█[0;1;32;92m█[0m         [0;1;33;93m██[0m
    [0;1;33;93m██[0m        [0;1;31;91m██[0m     [0;1;36;96m█[0;1;34;94m█[0m    [0;1;31;91m█[0;1;33;93m█[0m  [0;1;32;92m▄[0;1;36;96m▄▄[0;1;34;94m██[0;1;35;95m▄▄[0;1;31;91m▄[0m    [0;1;32;92m█[0;1;36;96m█▄[0;1;34;94m▄▄[0m   [0;1;31;91m▄[0;1;33;93m▄▄[0;1;32;92m██[0;1;36;96m▄▄[0;1;34;94m▄[0m     [0;1;33;93m██[0m        [0;1;31;91m██[0m
    [0;1;32;92m▀▀[0m        [0;1;33;93m▀▀[0m     [0;1;34;94m▀[0;1;35;95m▀[0m    [0;1;33;93m▀[0;1;32;92m▀[0m  [0;1;36;96m▀[0;1;34;94m▀▀[0;1;35;95m▀▀[0;1;31;91m▀▀[0;1;33;93m▀[0m     [0;1;34;94m▀▀[0;1;35;95m▀▀[0m   [0;1;33;93m▀[0;1;32;92m▀▀[0;1;36;96m▀▀[0;1;34;94m▀▀[0;1;35;95m▀[0m     [0;1;32;92m▀▀[0m        [0;1;33;93m▀▀[0m
"

if [ -z "$XDG_CONFIG_HOME" ]
then
  mili_config_location="$mili_location"
else
  mili_config_location="$XDG_CONFIG_HOME/mili"
fi

# inplace sed
function ised() {
  local exp=$1
  local location=$2

  if [[ $OSTYPE == darwin* ]]; then
    sed -i '' $exp $location
  else
    sed -i $exp $location
  fi
}

mili_location=$1

echo "# Mili, Automatic Login for MikroTik Services"
echo "# Version 0.1.0, Alpha A"
echo "-------------------------------------------"
echo "# Made with <3 by Sadegh Hayeri - (https://github.com/SadeghHayeri)"
echo
echo "# First you must enter the MikroTik URl"

echo "(For example if you're using https://example.com/login for login and https://example.com/logout for logout"
echo "you must enter https://example.com URL as the MikroTik URL)"
echo

function check_mikrotik_services() {
  return 0
  local base_url=$1
  curl -s "$base_url/login" | grep -e "logged" > /dev/null # TODO: add 'login required'

  return $?
}

function generate_basic_config() {
  cat > "$mili_config_location/config.json" <<- EOM
{
  "version": 0,
	"enable": true,
	"base_url": "<-BASEURL->",
	"login_information" : []
}
EOM
}

function check_and_save() {
  local username=$1
  local password=$2

  # ./mili.sh logout
  # ./mili.sh login $username $password
  echo
  echo 'OK'
  if [[ $? -eq 0 ]]; then
    cat "$mili_config_location/config.json" | jq ".login_information[.login_information | length] |= . + {\"username\": \"$username\", \"password\": \"$password\", \"share\": 1}" > "$mili_config_location/config.json.tmp"
    mv "$mili_config_location/config.json.tmp" "$mili_config_location/config.json"
  fi
}

function set_base_url() {
  base_url=''
  while [[ true ]]; do
    read -p 'Mikrotik URL: ' base_url
    echo 'Checking MikroTik Services...'
    check_mikrotik_services
    if [[ $? -eq 0 ]]; then
      echo "Successful"
      break
    else
      echo 'Bad URL, check MicroTick address'
      echo 'Try again'
      echo
    fi
  done
  ised "s|<-BASEURL->|$base_url|g" "$mili_config_location/config.json"
}

function add_login_information() {
  echo
  echo "# Now you can add login inforamtion"

  select option in 'Add new login info' 'End';
  do
    case $option in
      'Add new login info')
        read -r -p 'Username: ' username
        read -r -s -p 'Password: ' password
        check_and_save "$username" "$password"
        echo "# Now you can add login inforamtion"
        ;;
      'End')
        break
        ;;
      *)
        echo "# Only 1 or 2! please!"
        ;;
    esac
  done
}

generate_basic_config $mili_config_location
set_base_url
add_login_information
