#!/bin/bash

apt-get update
sudo apt-get install -y git
sudo apt-get install -y zsh
sudo apt-get install -y nodejs npm
sudo apt-get install -y vim
sudo apt-get install -y silversearcher-ag

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global difftool.prompt false
