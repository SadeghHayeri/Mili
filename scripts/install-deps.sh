#!/bin/bash

function install_if_not_found() {
  command=$1

  if ! which $command > /dev/null; then
    if [[ $OSTYPE == darwin* ]]; then
      brew install $command
    else
      sudo apt-get install -y $command
    fi
  fi
}

function install_linux_deps() {
  echo "Update apt-get..."
  sudo apt-get update

  echo "Installing packages..."
  install_if_not_found jq
  install_if_not_found curl
}

function install_darwin_deps() {
  echo "Check for Homebrew..."
  if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    echo "Update homebrew recipes..."
    brew update
  fi

  echo "Installing packages..."
  install_if_not_found jq
  install_if_not_found terminal-notifier
}

function main() {
  echo "Starting dependency check"
  case "$OSTYPE" in
    darwin*)
      install_darwin_deps
      ;;
    linux*)
      install_linux_deps
      ;;
    *)
      echo "Mili not support your OS: $OSTYPE";;
  esac
}

main
