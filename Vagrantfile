VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# Base box to build off, and download URL for when it doesn't exist on the user's system already
	config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vbox|
    vbox.name = "derby-notebook"
    vbox.memory = 1024
    vbox.cpus = 2
  end

	# Forward a port from the guest to the host, which allows for outside
	# computers to access the VM, whereas host only networking does not.
	config.vm.network "forwarded_port", guest: 8888, host: 8888,
    auto_correct: true
	config.vm.network "forwarded_port", guest: 9999, host: 9999,
    auto_correct: true

	# Enable provisioning with a shell script.
	config.vm.provision :shell,
    inline: <<-eos
       apt-get update
       apt-get install -y docker.io python-pip
       pip install -U fig
       usermod -a -G docker vagrant
       cd /vagrant && fig up
    eos
end
