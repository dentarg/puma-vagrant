# puma-vagrant

Setup on macOS with [Homebrew](https://brew.sh/)

    brew cask install virtualbox
    brew cask install vagrant
    vagrant plugin install dotenv

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

## FreeBSD

Currently broken: https://github.com/puma/puma/issues/2556

```bash
vagrant up freebsd
vagrant ssh freebsd

# In FreeBSD
export PATH=$PATH:/usr/home/vagrant/.gem/ruby/2.7/bin
gem install --user bundler
cd /vagrant/app
rm Gemfile.lock
bundle
bundle exec puma --config config.rb -p 5002

# To run Puma tests
sudo pkg install -y -r FreeBSD git devel/ragel
git clone https://github.com/puma/puma.git
cd puma
bundle
bundle exec rake
```

## OpenBSD

```bash
vagrant up openbsd
vagrant ssh openbsd

# In OpenBSD
cd /vagrant/app
bundle
sudo puma --log-requests --bind tcp://127.0.0.1:5001 --config config.rb --control-url unix:///var/www/run/puma.sock

sudo cp /vagrant/httpd.conf /etc/httpd.conf
sudo rcctl enable httpd
sudo rcctl start httpd
ftp -d -v -o - http://127.0.0.1

sudo cp /vagrant/relayd.conf /etc/relayd.conf
sudo rcctl enable relayd
sudo rcctl start relayd
ftp -d -v -o - http://127.0.0.1
curl -s -v 127.0.0.1
```

## JRuby

    echo "PUMA_SRC_DIR=<path to directory with puma>" >> .env.vagrant
    vagrant up jruby-ubuntu
    vagrant ssh
    cp -r /vagrant/ ~/puma && cd ~/puma && bundle && bundle e rake compile && bundle e rake test:all
