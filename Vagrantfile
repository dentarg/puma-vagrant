require "dotenv"
Dotenv.load(".env.vagrant")

ruby_version = File.read(".ruby-version").chomp
jruby_version = "9.2.13.0"

$provision = <<SCRIPT
set -e

sudo apt-get update

echo "Installing Ruby"
gpg --keyserver hkp://keys.gnupg.net \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --ruby=#{ruby_version}

echo "Install utilities"
sudo apt-get install -y git

echo "Installing gem dependencies for: json"
sudo apt-get install -y ruby-dev

echo "Installing gem dependencies for: nokogiri"
sudo apt-get install -y libxml2-dev libxslt-dev

echo "Installing gem dependencies for: pg"
sudo apt-get install -y libpq-dev
SCRIPT

gem_home = "/usr/local/bundle"

$jruby_provision = <<SCRIPT
set -e

sudo apt-get update

echo "Install utilities"
sudo apt-get install -y --no-install-recommends \
     ca-certificates \
     git \
     gnupg \
     wget \
     ragel \
     netbase \
     software-properties-common

wget -qO - "https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public" | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get -y install adoptopenjdk-8-hotspot=\*
echo "JAVA_HOME_8_X64=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64" | sudo tee -a /etc/environment

mkdir -p /home/runner/.rubies
wget -qO /tmp/jruby.tar.gz https://github.com/ruby/ruby-builder/releases/download/enable-shared/jruby-#{jruby_version}-ubuntu-18.04.tar.gz
sudo tar -xz -C /home/runner/.rubies -f /tmp/jruby.tar.gz
rm /tmp/jruby.tar.gz

sudo sh -c 'PATH=/home/runner/.rubies/jruby-#{jruby_version}/bin:$PATH gem install bundler -v "~> 2" --no-document'

echo "don't create '.bundle' in all our apps"
echo 'export BUNDLE_APP_CONFIG="#{gem_home}"' >> /home/vagrant/.bashrc
echo 'export BUNDLE_SILENCE_ROOT_WARNING=1' >> /home/vagrant/.bashrc

echo 'export GEM_HOME=#{gem_home}' >> /home/vagrant/.bashrc
echo 'export PATH=#{gem_home}/bin:/home/runner/.rubies/jruby-#{jruby_version}/bin:$PATH' >> /home/vagrant/.bashrc

echo "adjust permissions of a few directories for running 'gem install' as an arbitrary user"
mkdir -p #{gem_home} && chmod 777 #{gem_home}
SCRIPT

$freebsd_provision = <<SCRIPT
sudo pkg install -y -r FreeBSD devel/ruby-gems
SCRIPT

$openbsd_provision = <<SCRIPT
  sudo pkg_add ruby-#{ruby_version} vim--no_x11 curl
  sudo ln -sf /usr/local/bin/ruby26 /usr/local/bin/ruby
  sudo ln -sf /usr/local/bin/erb26 /usr/local/bin/erb
  sudo ln -sf /usr/local/bin/irb26 /usr/local/bin/irb
  sudo ln -sf /usr/local/bin/rdoc26 /usr/local/bin/rdoc
  sudo ln -sf /usr/local/bin/ri26 /usr/local/bin/ri
  sudo ln -sf /usr/local/bin/rake26 /usr/local/bin/rake
  sudo ln -sf /usr/local/bin/gem26 /usr/local/bin/gem
  sudo ln -sf /usr/local/bin/bundle26 /usr/local/bin/bundle
  sudo ln -sf /usr/local/bin/bundler26 /usr/local/bin/bundler
SCRIPT

Vagrant.configure(2) do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/bionic64"
    ubuntu.vm.hostname = "puma"
    ubuntu.vm.provision "shell", inline: $provision
    ubuntu.vm.synced_folder "./",
                            "/vagrant",
                            disabled: false,
                            SharedFoldersEnableSymlinksCreate: false
    ubuntu.vm.network :forwarded_port, host: 5000, guest: 5000
    ubuntu.vm.provider "virtualbox" do |vbox|
      # do not create ubuntu-*-cloudimg-console.log
      # from https://groups.google.com/forum/#!topic/vagrant-up/eZljy-bddoI
      vbox.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
    end
  end

  config.vm.define "jruby-ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/bionic64"
    ubuntu.vm.hostname = "jruby"
    ubuntu.vm.provision "shell", inline: $jruby_provision
    ubuntu.vm.synced_folder ENV.fetch("PUMA_SRC_DIR"),
                            "/vagrant",
                            disabled: false,
                            SharedFoldersEnableSymlinksCreate: false
    ubuntu.vm.network :forwarded_port, host: 5000, guest: 5000
    ubuntu.vm.provider "virtualbox" do |vbox|
      # do not create ubuntu-*-cloudimg-console.log
      # from https://groups.google.com/forum/#!topic/vagrant-up/eZljy-bddoI
      vbox.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
      vbox.memory = 2048
    end
  end

  config.vm.define "freebsd" do |freebsd|
    freebsd.vm.box = "bento/freebsd-12.2"
    freebsd.vm.hostname = "freebsd"
    freebsd.vm.provision "shell", inline: $freebsd_provision
    freebsd.vm.synced_folder "./", "/vagrant", disabled: false
    freebsd.vm.network :forwarded_port, host: 5002, guest: 5002
  end

  config.vm.define "openbsd" do |openbsd|
    openbsd.vm.box = "twingly/openbsd-6.6-amd64"
    openbsd.vm.hostname = "openbsd"
    openbsd.vm.provision "shell", inline: $openbsd_provision
    openbsd.vm.synced_folder "./", "/vagrant", disabled: false
    openbsd.vm.network :forwarded_port, host: 5001, guest: 5001
    openbsd.vm.network :forwarded_port, host: 8080, guest: 80
  end
end
