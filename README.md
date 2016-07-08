# Mezuro Playbooks

Ansible playbooks for setting up the mezuro.org services

## Requirements

* Ansible 2.0
* Managed machines set up with Ubuntu 16.04 - other versions of Ubuntu or Debian
  might work, but have not been tested

## Usage

### Install external modules

The playbooks require some modules from Ansible Galaxy. To install them, run:

`ansible-galaxy install -r requirements.yml -p roles.lib`

### Set up secrets.yml

The passwords for databases, and the Rails `SECRET_KEY_BASE` are stored in the
`secrets.yml` file. For the development environment, you can copy `secrets.yml.sample`,
which will be unencrypted. For production, it is *very, very* recommended to encrypt
the secrets using `ansible-vault`. To do that, run:

`ansible-vault encrypt secrets.yml.sample --output secrets.yml`.

Then, create a file named `.vault-pass` containing the password for the vault file.
This file should *never* be committed to source control. Alternatively, if you want
to be prompted for the password each time, remove the `vault_password_file` option
from `ansible.cfg`, and add `ask_vault_pass=yes`. Be aware that that will *very likely*
break automatic provisioning and/or Vagrant.

To edit the secrets, run:

`ansible-vault edit secrets.yml`

### Check meta.yml

`meta.yml` contains informations about the versions, repositories and ports of
each application. Verify/edit it before doing new deploys to ensure the correct
information is being used.

### Development environment - Vagrant

A Vagrant configuration for setting up an environment with Docker is availble.

To use it, run:

`vagrant up`

It should build the Docker images and create 3 containers, named `postgresql`,
`kalibro` and `prezento`, then provision the services through Ansible on them.

You can choose to run Ansible manually, by running `vagrant provision` (possibly 
after running `vagrant up` with the `--no-provision` argument), or if you
want to pass different options to Ansible:

`ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ...`


### Production environment

A hosts file containing the production mezuro.org setup is included in `production`.
It is not set up to be used automatically to avoid accidentally deploying to production.
To use it, pass `-i production` to Ansible, like this:

`ansible-playbook -i production site.yml`

## Deploying without doing the complete setup / deploying a single application

To avoid deploying all the applications again, and/or doing the whole pre-setup
process by installing PostgreSQL/RVM/etc, you should use the Ansible filtering 
capabilities. For example, to update only `kalibro_processor` run:

`ansible-playbook -i production --tags kalibro_processor site.yml`

To only deploy to a particular host:

`ansible-playbook -i production --limit postgresql site.yml`

It is recommended to do a full deploy whenever possible to ensure no issues with
ordering, missing packages or partial updates happen.

## License

This is licensed under GPLv3 (see COPYING file) by the AUTHORS (see AUTHORS file).
