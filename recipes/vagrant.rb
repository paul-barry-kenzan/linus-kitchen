
node.set[:vagrant][:url] = "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1_x86_64.deb"
node.set[:vagrant][:checksum] = "6615b95fcd8044e2f5e1849ec1004df5e05e390812558ec2c4b3dcec541b92da"
include_recipe "vagrant"

install_vagrant_plugin "vagrant-cachier", "1.1.0"
install_vagrant_plugin "vagrant-berkshelf", "4.0.2"
install_vagrant_plugin "vagrant-omnibus", "1.4.1"
install_vagrant_plugin "vagrant-lxc", "1.0.1"
install_vagrant_plugin "vagrant-toplevel-cookbooks", "0.2.3"

# notes: 
# * run `vagrant lxc sudoers` once
# * add `eval "$(chef shell-init bash)"` to bash profile
# * add `export VAGRANT_DEFAULT_PROVIDER=lxc` to bash profile
# * add `be` alias for `bundle exec`

# XXX - fix for https://github.com/mitchellh/vagrant/issues/5001
remote_file "/opt/vagrant/embedded/cacert.pem" do
  source "https://gist.githubusercontent.com/tknerr/71fc51b591db47541a46/raw/cacert.pem"
end
