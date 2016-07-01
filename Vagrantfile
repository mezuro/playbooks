# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # For reference see https://www.vagrantup.com/docs/docker/configuration.html
  config.vm.provider "docker" do |d|
    d.build_dir = '.'
    d.build_args = '--tag=systemd_sshd_ubuntu'
    d.has_ssh = true #FIXME: Vagrant should be able to set the ssh configurations
    d.create_args = ['--cap-add=SYS_ADMIN']
    d.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:ro"]

    if File.directory?("/sys/fs/selinux")
      d.volumes << "/sys/fs/selinux:/sys/fs/selinux:ro"
    end
  end

  config.ssh.username = 'root'
  config.ssh.password = 'mezuro'

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "site.yml"
  end

  config.vm.define "prezento" do |prezento|
    prezento.vm.network "forwarded_port", guest: 22, host: 50022, id: 'ssh'
    prezento.vm.network "forwarded_port", guest: 8085, host: 50085
  end

  config.vm.define "postgresql" do |postgresql|
    postgresql.vm.network "forwarded_port", guest: 22, host: 50122
  end

  config.vm.define "kalibro" do |kalibro|
    kalibro.vm.network "forwarded_port", guest: 22, host: 50222, id: 'ssh'
  end
end
