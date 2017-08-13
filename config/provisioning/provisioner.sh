#!/usr/bin/env bash

echo ". ~/.bash_prompt_git_branch" >> ~/.bashrc

# Ruby
sudo apt-get install -y software-properties-common
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update -y

sudo dpkg-reconfigure tzdata
sudo apt-get install -y ntp build-essential git-core imagemagick zip pigz ruby2.3 ruby2.3-dev xfonts-base xfonts-75dpi libpq-dev postgresql-client postgresql postgresql-contrib

sudo gem install bundler

sudo apt-get -f install
sudo apt-get autoremove -y

cd ~
ln -s /vagrant ~/development

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

# Install nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y nodejs
