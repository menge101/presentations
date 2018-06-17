#!/bin/bash --login

function install_rvm() {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

    echo -n "Install RVM? (y/n)"
    read input
    install=$(echo $input | tr '[:upper:]' '[:lower:]')

    if [ ${install} == "y" ]; then
        curl -sSL https://get.rvm.io | bash
        source ${HOME}/.bash_profile
    else
        echo "Observed non 'y' answer, rvm will not install."
    fi
}

function install_ruby_version_management() {
    if ! command -v rvm &> /dev/null; then
        if command -v rbenv &> /dev/null; then
            echo "You are using rbenv, rvm will not be installed.  You are on your own for setup of ruby version and gem management."
            echo "Please enhance this script to support rbenv! :)"
            exit 0
        else
            install_rvm
        fi
    else
        echo "RVM already installed"
    fi
}

function install_ruby_via_rvm() {
    echo "Installing ruby version: $1"
    echo "This can be slow, please be patient"
    rvm install $1 > /dev/null
    echo "Hopefully installation was successful!"
}

if ! command -v brew &> /dev/null; then
    echo "Please install brew. You will need it."
    exit 0
fi

current_ruby_version=$(cat ./.ruby-version)
install_ruby_version_management
install_ruby_via_rvm ${current_ruby_version}
cd .
rvm use ${current_ruby_version}@presentations --create

if ! command -v bundle &> /dev/null; then
    gem install bundler
fi

brew bundle
PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig BUNDLE_GEMFILE=VimdeckGemfile bundle install
