ruby_version = File.read(".ruby-version").chomp
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

Vagrant.configure(2) do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.vm.define "puma" do |ubuntu|
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
end
