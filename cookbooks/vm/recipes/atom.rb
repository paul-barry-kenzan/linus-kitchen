
if docker?
  # we need xvfb + libasound2 for starting atom in docker
  package 'xvfb'
  package 'libasound2'
  # avoid /dev/fuse issues on circleci
  extra_options = '--no-install-recommends'
end

# install atom
remote_file "#{Chef::Config[:file_cache_path]}/atom-1.7.3-amd64.deb" do
  source 'https://github.com/atom/atom/releases/download/v1.7.3/atom-amd64.deb'
  mode 0644
end
bash 'install-atom' do
  code <<-EOF
    dpkg -i #{Chef::Config[:file_cache_path]}/atom-1.7.3-amd64.deb
    apt-get -f -y install #{extra_options}
    EOF
  not_if "which atom && #{docker? ? 'xvfb-run' : 'DISPLAY=:0'} atom -v | grep -q '1.7.3'"
end

# install plugins
plugins = {
  'atom-beautify' => '0.29.7',
  'minimap' => '4.23.5',
  'line-ending-converter' => '1.3.2',
  'language-chef' => '0.9.0',
  'language-batchfile' => '0.4.0'
}
plugins.each do |name, version|
  install_atom_plugin(name, version)
end

# config tweaks
template "#{devbox_userhome}/.atom/config.cson" do
  source 'atom_config.erb'
  owner devbox_user
  group devbox_user
  mode '0664'
end
