# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = 'ubuntu/trusty64' # Other upgraded options: [ubuntu/xenial64, bento/ubuntu-16.04 ]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:3100" will access port 3100 on the guest machine.
  config.vm.network 'forwarded_port', guest: 3300, host: 3300
  config.vm.network 'forwarded_port', guest: 8080, host: 8080

  config.ssh.forward_agent = true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # Required for NFS to work, pick any local IP
  # config.vm.network 'private_network', ip: '192.168.33.10'

  config.vm.synced_folder '.', '/vagrant', type: 'rsync', rsync__auto: true, rsync__exclude: ['.git/', 'public/', 'tmp/pids/'], id: 'development'

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    vb.name = 'Development VM'

    host = RbConfig::CONFIG['host_os']

    # Give VM 1/3 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 3
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 3
    else # sorry Windows folks, I can't help you
      cpus = 2
      mem = 2500
    end

    # Customize the amount of memory on the VM:
    vb.memory = mem
    vb.cpus = cpus

    vb.customize ['modifyvm', :id, '--nictype1', 'virtio']
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.provision 'file', source: 'config/provisioning/.gemrc', destination: '~/.gemrc'
  config.vm.provision 'file', source: 'config/provisioning/.screenrc', destination: '~/.screenrc'
  config.vm.provision 'file', source: 'config/provisioning/.bash_prompt_git_branch', destination: '~/.bash_prompt_git_branch'
  config.vm.provision 'file', source: 'config/provisioning/.irbrc', destination: '~/.irbrc'
  config.vm.provision 'shell', path: 'config/provisioning/provisioner.sh', privileged: false
end
