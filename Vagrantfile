Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/focal64"

	# Port forwarding
	config.vm.network 'forwarded_port', guest: 27017, host: 27017


	config.vm.provider "virtualbox" do |vb|
		vb.name = "mongodb.local.x-shell.codes"
		vb.cpus = 1
		vb.memory = 4096
	end
end
