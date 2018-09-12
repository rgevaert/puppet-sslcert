require 'spec_helper'

describe 'sslcert::cert', :type => :define do
  context "default" do
  let(:params) {
    {
      :certname  => 'ided.ugent.be',
      :certpath  => '/etc/ssl/certpath.crt',
      :keypath   => '/etc/ssl/keypath.key'
    }
  }
  let(:title) { 'ided.ugent.be' }

  it { is_expected.to compile }
  content = "# Managed by Puppet
# puppet-sslcert
---
auto_cert_renewal_certificates:
        ided.ugent.be:
                certificate_file: \"/etc/ssl/certpath.crt\"
                key_file: \"/etc/ssl/keypath.key\"
"
  it { is_expected.to contain_file('/etc/facter/facts.d/facts-ided.ugent.be-certificate.yaml')
    .with_content(content)
   }

  end
  context "default2" do
    let(:params) {
      {
        :certname  => 'ided.ugent.be',
        :certpath  => '/etc/ssl/certpath.crt',
        :chainpath => '/etc/ssl/certpath.chain',
        :keypath   => '/etc/ssl/keypath.key'
      }
    }
    let(:title) { 'ided.ugent.be' }

    it { is_expected.to compile }
    content = "# Managed by Puppet
# puppet-sslcert
---
auto_cert_renewal_certificates:
        ided.ugent.be:
                certificate_file: \"/etc/ssl/certpath.crt\"
                chain_file: \"/etc/ssl/certpath.chain\"
                key_file: \"/etc/ssl/keypath.key\"
"
    it { is_expected.to contain_file('/etc/facter/facts.d/facts-ided.ugent.be-certificate.yaml')
      .with_content(content)
    }

  end
  context "default all" do
    let(:params) {
      {
        :certname  => 'ided.ugent.be',
        :certpath  => '/etc/ssl/certpath.crt',
        :chainpath => '/etc/ssl/certpath.chain',
        :keypath   => '/etc/ssl/keypath.key',
        :san_names => 'test,test,test',
        :renew_key => "true",
        :certificate_type => "ssl_multi_domain",
        :ssl_service_name => "ssl_service",
        :ssl_service_command => "restarted",
      }
    }
    let(:title) { 'ided.ugent.be' }

    it { is_expected.to compile }
    content = "# Managed by Puppet
# puppet-sslcert
---
auto_cert_renewal_certificates:
        ided.ugent.be:
                certificate_file: \"/etc/ssl/certpath.crt\"
                chain_file: \"/etc/ssl/certpath.chain\"
                san_names: \"test,test,test\"
                renew_key: \"true\"
                certificate_type: \"ssl_multi_domain\"
                ssl_service_name: \"ssl_service\"
                ssl_service_command: \"restarted\"
                key_file: \"/etc/ssl/keypath.key\"
"
    it { is_expected.to contain_file('/etc/facter/facts.d/facts-ided.ugent.be-certificate.yaml')
      .with_content(content)
    }

  end
end
