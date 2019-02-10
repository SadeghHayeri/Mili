#!/bin/bash

function install_linux_deps() {
  echo "Update apt-get..."
  sudo apt-get update

  echo "Installing packages..."
  PACKAGES=(
    jq
    curl
  )
  sudo apt-get install -y ${PACKAGES[@]}
}

function install_darwin_deps() {
  echo "Check for Homebrew..."
  if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo "Update homebrew recipes..."
  brew update

  PACKAGES=(
    jq
    terminal-notifier
  )
  echo "Installing packages..."
  brew install ${PACKAGES[@]}

  echo "Cleaning up..."
  brew cleanup
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
