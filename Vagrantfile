Vagrant.configure('2') do |config|
  config.vm.box         = "ubuntu/trusty64"
  config.vm.hostname    = "deep-learning-vm"
  

  config.vm.provider "virtualbox" do |v|
    v.cpus   = 4
    v.memory = 4096

    # Explicitly setting the name, otherwise the default looks like : 
    # deep-learning-vm_default_1462004539...
    v.name   = "deep-learning-vm"
  end

  config.vm.provision "file", source: "requirements.txt", destination: "/home/vagrant/requirements.txt"
  config.vm.provision :shell, path: 'setup.sh', keep_color: true

  config.vm.synced_folder "notebooks/", "/home/vagrant/notebooks"
  config.vm.synced_folder "../data/", "/home/vagrant/data"
  config.vm.synced_folder "examples/", "/home/vagrant/examples"

  config.vm.network "forwarded_port", guest: 8100, host: 8100, auto_correct: true
  config.vm.network "forwarded_port", guest: 6006, host: 6006, auto_correct: true
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    /home/vagrant/miniconda/bin/ipython notebook --notebook-dir=/home/vagrant/notebooks --port 8100 --ip=0.0.0.0 &
  SHELL

end

