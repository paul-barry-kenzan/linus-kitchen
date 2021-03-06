
#
# return a minimal sane environment for the devbox user to be used in bash resources
# see https://tickets.opscode.com/browse/CHEF-2288
#
def devbox_user_env
  {
    'HOME' => devbox_userhome,
    'USER' => devbox_user
  }
end

def devbox_user
  node['devbox']['user']
end

def devbox_group
  node['devbox']['group']
end

def devbox_password
  node['devbox']['password']
end

def devbox_userhome
  "/home/#{devbox_user}"
end

#
# reopen the Chef::Recipe class for being able to use it like any other resource
#
class Chef
  class Recipe # rubocop:disable Style/Documentation
    #
    # workaround until the `vagrant_plugin` provider of the `vagrant` cookbook
    # supports passing the VAGRANT_HOME environment
    #
    def install_vagrant_plugin(name, version)
      bash "install vagrant plugin #{name}-#{version} for #{devbox_user}" do
        user devbox_user
        group devbox_group
        environment devbox_user_env
        code "vagrant plugin install #{name} --plugin-version #{version}"
        not_if "vagrant plugin list | grep -q '#{name} (#{version})'",
               user: devbox_user,
               group: devbox_group,
               environment: devbox_user_env
      end
    end

    #
    # atom_apm does not work, so we use a bash resource, see
    # https://github.com/mohitsethi/chef-atom/issues/2
    #
    def install_atom_plugin(name, version)
      bash "install atom plugin #{name}@#{version} for #{devbox_user}" do
        user devbox_user
        group devbox_group
        environment devbox_user_env
        code "apm install #{name}@#{version}"
        not_if "apm list --installed --bare | grep -q '#{name}@#{version}'",
               user: devbox_user,
               group: devbox_group,
               environment: devbox_user_env
      end
    end
  end
end
