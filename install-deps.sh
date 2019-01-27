#!/bin/bash

echo "Starting dependency check"

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
