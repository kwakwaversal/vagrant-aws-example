# vagrant-aws-example
Example configuration to deploy an AWS EC2 instance using Vagrant.

# Summary
To refamiliarise myself with [Vagrant](https://www.vagrantup.com/) and [Amazon Web Services](https://aws.amazon.com/) I wanted to write a `Vagrantfile` to automatically build a basic EC2 instance. References that I used to complete this task exist at the foot of this README.

This is not a complete tutorial for deploying an AWS instance. This assumes you know how to use AWS to create a user in IAM, create your private key pair, and create a network policy to secure an instance.

N.B., My development machine is a Windows 10 laptop, so some instructions will be specific to that OS.

# Usage
Vagrant providers need to be installed before you can use them. AWS isn't a default provider, so if you want to manage AWS instances you need to install it. If you have a fresh install, install the plugin first.

```bash
$ vagrant plugin install vagrant-aws
```

As per the [official plugin documentation](https://github.com/mitchellh/vagrant-aws), you need to use a dummy AWS box and configure specific details of the instance manually in a `config.vm.provider` block.

```bash
vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
```

You're now just one step away from deployment. Update your `Vagrantfile` configuration using the help below, and then 'up' it. Magic!

```bash
vagrant up --provider=aws
```

N.B., If you're on windows, you will also need to install [Cygwin](https://www.cygwin.com/install.html). This is because the default way of mounting the `/vagrant` folder is using `rsync`. Install `rsync` and `ssh` and make sure the relevant `bin` folder is in your `PATH`.

## Configuration
This repository's `Vagrantfile` will not work out of the box for you. You'll need to set up the environmental variables and a few extra options to get it to work.

### Environmental variables
There are 4 Environmental variables set to get this example to work. They are `AWS_KEY`, `AWS_SECRET`, `AWS_KEYNAME` and `AWS_KEYPATH`.

Rather than create a user with unlimited access to your AWS account, it's advisable to create a user with just the `AmazonEC2FullAccess` policy set. This can be done under `security credentials` in your AWS account.

### Extra options
These extra options are assuming that you're testing this `Vagrantfile` on the free tier. You'll need to modify them accordingly, and in the case of `aws.security_groups` you'll need to set up a group policy under the `Network & Security` section of the AWS portal. For this example, I've set up an inbound `SSH` and `HTTP` rule for my IP address.

```ruby
# AMI = Amazon Machine Image, select the Ubuntu Server 14.04 LTS image for your region
aws.ami = "ami-ed82e39e"
# The region to start the image in, such as "us-east-1"
aws.region = "eu-west-1"
# The type of instance (I've defaulted it to a free tier type)
aws.instance_type = "t2.micro"
# Create a security policy so you can SSH to the box to complete the install
aws.security_groups = ["Vagrant"]
```

# Gotchas
I came across some gotchas while trying to set this up. Most of them were easily fixed with a bit of Googling, but one was a bit of a pain to track down and fix.

Once a remote instance has been brought up, Vagrant tries to use `rsync` to synchronise the root folder with the instance. This was failing with:

```bash
There was an error when attempting to rsync a synced folder.
Please inspect the error message below for more info.

Host path: /cygdrive/d/My/Vagrants/vagrant_aws/
Guest path: /vagrant
Command: "rsync" "--verbose" "--archive" "--delete" "-z" "--copy-links" "--chmod=ugo=rwX" "--no-perms" "--no-owner" "--no-group" "--rsync-path" "sudo rsync" "-e" "ssh -p 22 -o StrictHostKeyChecking=no -o IdentitiesOnly=true -o UserKnownHostsFile=/dev/null -i 'D:/My/Vagrants/id_rsa'" "--exclude" ".vagrant/" "/cygdrive/d/My/Vagrants/vagrant_aws/" "ubuntu@ec2-52-30-240-91.eu-west-1.compute.amazonaws.com:/vagrant"
Error: Warning: Permanently added 'ec2-52-30-240-91.eu-west-1.compute.amazonaws.com,52.30.240.91' (ECDSA) to the list of known hosts.
dup() in/out/err failed
rsync: connection unexpectedly closed (0 bytes received so far) [sender]
rsync error: error in rsync protocol data stream (code 12) at io.c(226) [sender=3.1.2]
```

[Other people](https://github.com/mitchellh/vagrant/issues/6677) had this problem too.

I found that the issue was because I didn't have the `ssh` bundled with my Cygwin install. When you're installing Cygwin, it recommends you only install what you need. As such, I only selected `rsync` because I had a working `ssh` with my Windows `git` installation. As you've already guessed, they're not compatible!

The fix was to add Cygwin's version of `ssh` to the Cygwin installation, and for good measure, I removed the `git`  `PATH` to make sure that `rsync` was using the `ssh` that was part of the same distribution as itself.

# References
- [Vagrant AWS Provider (official plugin)](https://github.com/mitchellh/vagrant-aws)
- [AWS Automation based on Vagrant — Part 2](https://oliverveits.wordpress.com/2016/04/01/aws-automation-using-vagrant-a-hello-world-example/)
