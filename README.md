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

    mkcert -install

    # Only install for Firefox, if you want to avoid use of sudo
    TRUST_STORES=nss mkcert -install

    cd ssl_app
    mkcert -cert-file puma_cert.pem -key-file puma_key.pem localhost 127.0.0.1 ::1

    bundle exec puma -C ssl_config.rb

Open [https://localhost:9292/](https://localhost:9292/) or [https://127.0.0.1:9292/](https://127.0.0.1:9292/).

## OpenBSD

```
vagrant up openbsd
vagrant ssh openbsd

cd /vagrant/app
bundle
sudo puma --log-requests --bind tcp://127.0.0.1 --config config.rb --control-url unix:///var/www/run/puma.sock

sudo cp /vagrant/httpd.conf /etc/httpd.conf
sudo rcctl enable httpd
sudo rcctl start httpd
ftp -o - http://127.0.0.1
```
