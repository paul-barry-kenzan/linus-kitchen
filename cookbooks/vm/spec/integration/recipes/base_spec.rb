require 'spec_helper'

describe 'vm::base' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'installs vim' do
    expect(package('vim')).to be_installed
    expect(command('vim --version').exit_status).to eq 0
  end

  it 'installs development headers for installing nokogiri etc.' do
    %w(libxml2-dev libxslt1-dev zlib1g-dev liblzma-dev).each do |pkg|
      expect(package(pkg)).to be_installed
    end
  end

  it 'does not leave anything root-owned in ~/.chefdk' do
    expect(file('/home/vagrant/.chefdk/gem')).to be_owned_by 'vagrant'
  end
end
