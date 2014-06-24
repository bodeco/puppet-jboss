# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "windows2008r2"
  config.vm.guest = :windows
  config.ssh.username = 'vagrant'

  config.winrm.username = 'vagrant'
  config.winrm.password = 'vagrant'

  config.vm.communicator = 'winrm'

  config.vm.synced_folder './' , '/ProgramData/PuppetLabs/puppet/etc/modules/jboss'
  config.vm.synced_folder 'spec/fixtures/modules' , '/temp/modules'

  config.vm.provider :vmware_fusion do |v, override|
    v.gui = true
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
    #v.vmx["ethernet0.virtualDev"] = "vmxnet3"
    #v.vmx["RemoteDisplay.vnc.enabled"] = "false"
    #v.vmx["RemoteDisplay.vnc.port"] = "5900"
    #v.vmx["scsi0.virtualDev"] = "lsisas1068"
  end

  config.vm.provision :shell, :inline => 'puppet apply --modulepath "C:/ProgramData/PuppetLabs/puppet/etc/modules;C:/temp/modules" --verbose --diff "C:/Program Files/Tools/bin/diff.exe"--show_diff C:/ProgramData/PuppetLabs/puppet/etc/modules/jboss/tests/init.pp'

  # Puppet provisioning is hanging for unknown reasons:
  #config.vm.provision :puppet, :options => ['--modulepath C:/ProgramData/PuppetLabs/puppet/etc/modules;C:/temp/modules --verbose'] do |puppet|
  #  puppet.manifests_path = 'tests'
  #  puppet.manifest_file = 'init.pp'
  #end
end
