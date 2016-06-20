require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'sslcert')

    forge_modules = ['puppetlabs/stdlib']
    hosts.each do |host|
      forge_modules.each do |m|
        on host, puppet('module','install',m), { :acceptable_exit_codes => [0,1] }
      end

      # Required for manifest to make mod_pagespeed repository available
      # Hiera
      # Hierdoor worden de yaml files onder de fixtures op de SUT gezet.
      # Waar deze worden gezet is een beetje hocuspocus!
      # in de SUT config zetten we type op AIO en de hieradatdir.
      copy_hiera_data_to(host, 'spec/fixtures/hieradata/')
    end
  end
end
