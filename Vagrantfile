# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://github.com/mitchellh/vagrant-aws
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET']
    aws.keypair_name = ENV['AWS_KEYNAME']

    aws.ami = "ami-ed82e39e"
    aws.region = "eu-west-1"
    aws.instance_type = "t2.micro"
    aws.security_groups = ["Vagrant"]

    aws.tags = {
      'Name'    => 'MyAWS',
      'Client'  => 'Bananas',
    }

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['AWS_KEYPATH']
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision :shell, path: "bootstrap.sh"
end
