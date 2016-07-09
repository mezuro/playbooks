# -*- mode: ruby -*-
# vi: set ft=ruby :.

# Avoid having multiple docker images built at once, or Ansible being run before
# some of the VMs are up
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure("2") do |config|
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'

  config.vm.provider "docker" do |d|
    d.build_dir = './docker'    
    d.has_ssh = true
    d.create_args = ['--cap-add=SYS_ADMIN']
    d.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:ro"]

    if File.directory?("/sys/fs/selinux")
      d.volumes << "/sys/fs/selinux:/sys/fs/selinux:ro"
    end
  end

  config.vm.provider "virtualbox" do |vb, override|
    vb.memory = 1024
    vb.cpus = 2
    override.vm.box = "xenial64"
  end

  config.vm.provider "libvirt" do |lv, override|
    lv.driver = "kvm"
    lv.memory = 1024
    lv.cpus = 2
    override.vm.box = "nrclark/xenial64-minimal-libvirt"
  end

  config.vm.define "postgresql" do |postgresql|
    postgresql.vm.network "forwarded_port", guest: 22, host: 50122, id: 'ssh'
    
    postgresql.vm.provider "docker" do |d|
      d.build_args = ['--tag', 'mezuro-ubuntu-systemd:latest']
      d.expose += [5432]
      d.volumes += ["/var/lib/postgresql"]
    end
  end

  config.vm.define "kalibro" do |kalibro|
    kalibro.vm.network "forwarded_port", guest: 22, host: 50222, id: 'ssh'
    
    kalibro.vm.provider "docker" do |d|
      d.build_args = ['--tag', 'mezuro-ubuntu-systemd:latest']
      d.expose += [8082, 8083]
    end

  end

  config.vm.define "prezento" do |prezento|
    prezento.vm.network "forwarded_port", guest: 22, host: 50022, id: 'ssh'
    prezento.vm.network "forwarded_port", guest: 8085, host: 50085

    prezento.vm.provider "docker" do |d|
      d.build_args = ['--tag', 'mezuro-ubuntu-systemd:latest']
      d.expose += [8085]
    end

    # Provision all the machines together when the last is done
    prezento.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.limit = "all"
      ansible.playbook = "site.yml"
      ansible.groups = {
        "prezento_servers"               => ["prezento"],
        "db_servers"                     => ["postgresql"],
        "kalibro_processor_servers"      => ["kalibro"],
        "kalibro_configurations_servers" => ["kalibro"]
      }
    end
  end
end
