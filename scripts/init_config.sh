#!/bin/bash

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

cat ../asserts/banner.txt

echo "# Mili, Automatic Login for MikroTik Services"
echo "# Version 0.1.0, Alpha A"
echo "-------------------------------------------"
echo "# Made With <3 by Sadegh Hayeri - (https://github.com/SadeghHayeri)"
echo
echo "# First you must enter your MikroTik URl"

echo "(For example if you using https://example.com/login for login and https://example.com/logout for logout"
echo "you must enter general https://example.com URL as an input)"
echo

function check_mikrotik_services() {
  return 0
  local base_url=$1
  curl -s "$base_url/login" | grep -e "logged" > /dev/null # TODO: add 'login required'

  return $?
}

function generate_basic_config() {
  cp ../asserts/config.json "$mili_location/config.json"
}

function check_and_save() {
  local username=$1
  local password=$2

  # ./mili.sh logout
  # ./mili.sh login $username $password
  echo
  echo 'OK'
  if [[ $? -eq 0 ]]; then
    cat "$mili_location/config.json" | jq ".login_information[.login_information | length] |= . + {\"username\": \"$username\", \"password\": \"$password\", \"share\": 1}" > "$mili_location/config.json.tmp"
    mv "$mili_location/config.json.tmp" "$mili_location/config.json"
  fi
}

function set_base_url() {
  base_url=''
  while [[ true ]]; do
    read -p 'Mikrotik URL: ' base_url
    echo 'Checking for MikroTik Services...'
    check_mikrotik_services
    if [[ $? -eq 0 ]]; then
      echo "Successful"
      break
    else
      echo 'Bad URL, check address'
      echo 'Try again'
      echo
    fi
  done
  ised "s|<-BASEURL->|$base_url|g" "$mili_location/config.json"
}

function add_login_information() {
  echo
  echo "# Now you can add your login inforamtion"

  select option in 'Add new login info' 'End';
  do
    case $option in
      'Add new login info')
        read -p 'Username: ' username
        read -s -p 'Password: ' password
        check_and_save $username $password
        echo "# Now you can add your login inforamtion"
        ;;
      'End')
        break
        ;;
      *)
        echo "# Only 1 or 2 please!"
        ;;
    esac
  done
}

generate_basic_config $mili_location
set_base_url
add_login_information
