#!/bin/bash

cat banner.txt

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
  local base_url=$1
  curl -s "$base_url/login" | grep -e "logged" > /dev/null # TODO: add 'login required'

  return $?
}

base_url=''
while [[ true ]]; do
  base_url=$(read -p 'Mikrotik URL: ' )

  echo 'Checking for MikroTik Services...'
  check_mikrotik_services
  if [ $? -eq 0 ]; then
    echo "Successful"
    break
  else
    echo 'Bad URL, check address'
    echo 'Try again'
    echo
  fi
done

echo $base_url
