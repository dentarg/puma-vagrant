# puma-vagrant

Setup on macOS with [Homebrew](https://brew.sh/)

    brew cask install virtualbox
    brew cask install vagrant

Start the machine

    vagrant up

Access it

* Alternative 1

        vagrant ssh

* Alternative 2

        ssh vagrant@127.0.0.1 -p 2222 -o StrictHostKeyChecking=no -i ~/.vagrant.d/insecure_private_key

Fix permissions for RVM and install Bundler

    /vagrant/vagrant_bootstrap

Bundle your app

    cd /vagrant/app
    bundle

## HTTPS

    brew install mkcert
    brew install nss

    # Only install for Firefox, avoids use of sudo
    TRUST_STORES=nss mkcert -install

    cd ssl_app
    mkcert -cert-file puma_cert.pem -key-file puma_key.pem localhost 127.0.0.1 ::1

    bundle exec puma -C ssl_config.rb
