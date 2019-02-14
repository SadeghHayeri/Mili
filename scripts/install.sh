#!/bin/bash

case "$OSTYPE" in
  darwin*)
    user=$(id -un)
    mili_location="/Users/$user/.mili"
    script_location="$mili_location/bin"
    service_location="/Users/$user/Library/LaunchAgents"
    ;;
  linux*)
    user=$(id -un)
    mili_location="/home/$user/.mili"
    script_location="$mili_location/bin"
    service_location="/etc/systemd/system"
    ;;
  *)
    echo "Mili not support your OS: $OSTYPE"
    exit 1
    ;;
esac

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

function install_mili_scripts() {
  echo "Install Mili scripts..."
  mkdir -p $script_location
  cp ./mili.sh "$script_location/mili.sh"
  cp ./init_config.sh "$script_location/init_config.sh"
  cp ../logo/logo.png "$mili_location/logo.png"
  ised "s|<-USER->|$user|g" "$script_location/mili.sh"
  ised "s|<-MILI-LOCATION->|$mili_location|g" "$script_location/mili.sh"
  chmod +x "$script_location/mili.sh"
}

function add_startup_service() {
  echo "Add MikroTik service..."

  if [[ $OSTYPE == darwin* ]]; then
    cp ../asserts/com.mikrotik.mili.plist "$service_location/com.mikrotik.mili.plist"
    ised "s|<-USER->|$user|g" "$service_location/com.mikrotik.mili.plist"

    echo "Enable MikroTik service..."
    launchctl remove com.mikrotik.mili
    launchctl load -w "/Users/$user/Library/LaunchAgents/com.mikrotik.mili.plist"
    launchctl start com.mikrotik.mili
  else
    sudo rm -f /etc/network/if-up.d/mili
    sudo ln -s "$script_location/mili.sh" /etc/network/if-up.d/mili
  fi
}

function install_mili_gui() {
  echo "Install Mili App..."
  cp -r ../app/Mili.app /Applications/Mili.app
}

# TODO: support fish and zsh
function install_auto_complete() {
  echo "Install Auto Complete..."
  cp ./mili-auto-complete.sh "$script_location/mili-auto-complete.sh"
  ised "s|<-USER->|$user|g" "$script_location/mili-auto-complete.sh"
  echo "source $script_location/mili-auto-complete.sh" >> ~/.bashrc

  # sample for fish
  if which fish > /dev/null; then
    complete -c mili -xa "login status logout"
    echo complete -c mili -xa "\"login status logout\"" >> ~/.config/fish/config.fish
  fi
}

function install_mili_cli() {
  echo "Install Mili Command Line..."
  sudo rm -f /usr/local/bin/mili
  sudo ln -s "$script_location/mili.sh" /usr/local/bin/mili

  install_auto_complete
}

function main() {
  mkdir -p $mili_location
  ./install-deps.sh

  install_mili_scripts
  add_startup_service

  install_mili_cli
  if [[ $OSTYPE == darwin* ]]; then
    install_mili_gui
  fi
}

main
