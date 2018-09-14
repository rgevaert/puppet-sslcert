require 'spec_helper'

describe 'sslcert::cert', :type => :define do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:pre_condition) {'include ::sslcert'}

        context "default" do
          let(:params) {
            {
              :certname => 'ided.ugent.be',
              :key => 'key',
              :chain => 'chain',
              :cert => 'cert',
            }
          }
          let(:title) { 'other.ugent.be' }
          case facts[:osfamily]
            when 'Debian' then
              defaultPathCert = '/etc/ssl/certs/'
              defaultPathKey = '/etc/ssl/private/'
              break
            when 'RedHat' then
              defaultPathCert = '/etc/pki/tls/private/'
              defaultPathKey = '/etc/ssl/private/'
              break

          end
          it { is_expected.to compile }
          content = "# Managed by Puppet
# puppet-sslcert
---
auto_cert_renewal_certificates:
        other.ugent.be:
                certificate_file: \"${defaultPathCert}ided.ugent.be\"
                certificate_mode: \"0644\"
                certificate_owner: \"root\"
                certificate_group: \"root\"
                chain_file: \"${defaultPathCert}ided.ugent.be.chain\"
                chain_mode: \"0644\"
                chain_owner: \"root\"
                chain_group: \"root\"
                key_file: \"${defaultPathKey}ided.ugent.be.key\"
                key_mode: \"0600\"
                key_owner: \"root\"
                key_group: \"root\""
          it { is_expected.to contain_file('/etc/facter/facts.d/facts-other.ugent.be-certificate.yaml')
            .with_content(content)
          }

          it { is_expected.to contain_file("${defaultPathCert}ided.ugent.be").with(
            :content => 'cert'
          )}
          it { is_expected.to contain_file("${defaultPathCert}ided.ugent.be.chain").with(
            :content => 'chain'
          )}
          it { is_expected.to contain_file("${defaultPathKey}ided.ugent.be").with(
            :content => 'key'
          )}



        end
        context "Additional parameter chain" do
          let(:params) {
            {
              :certname  => 'ided.ugent.be',
              :certfile  => '/etc/ssl/certpath.crt',
              :chainfile => '/etc/ssl/certpath.chain',
              :keyfile   => '/etc/ssl/keypath.key'
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
                certificate_mode: \"0644\"
                certificate_owner: \"root\"
                certificate_group: \"root\"
                chain_file: \"/etc/ssl/certpath.chain\"
                chain_mode: \"0644\"
                chain_owner: \"root\"
                chain_group: \"root\"
                key_file: \"/etc/ssl/keypath.key\"
                key_mode: \"0600\"
                key_owner: \"root\"
                key_group: \"root\""
          it { is_expected.to contain_file('/etc/facter/facts.d/facts-ided.ugent.be-certificate.yaml')
            .with_content(content)
          }

        end
        context "All parameters" do
          let(:params) {
            {
              :certname            => 'ided.ugent.be',
              :certfile            => '/etc/ssl/certpath.crt',
              :certpath            => 'not used because of file',
              :chainfile           => '/etc/ssl/certpath.chain',
              :chainpath           => 'not used because of file',
              :common_name         => 'common_name.ugent.be',
              :keyfile             => '/etc/ssl/keypath.key',
              :keypath             => 'not used because of keyfile',
              :san_names           => 'test,test,test',
              :renew_key           => "true",
              :certtype            => "ssl_multi_domain",
              :ssl_service_name    => "ssl_service",
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
                certificate_mode: \"0644\"
                certificate_owner: \"root\"
                certificate_group: \"root\"
                certificate_type: \"ssl_multi_domain\"
                chain_file: \"/etc/ssl/certpath.chain\"
                chain_mode: \"0644\"
                chain_owner: \"root\"
                chain_group: \"root\"
                common_name: \"common_name.ugent.be\"
                san_names: \"test,test,test\"
                renew_key: \"true\"
                ssl_service_name: \"ssl_service\"
                ssl_service_command: \"restarted\"
                key_file: \"/etc/ssl/keypath.key\"
                key_mode: \"0600\"
                key_owner: \"root\"
                key_group: \"root\""
          it { is_expected.to contain_file('/etc/facter/facts.d/facts-ided.ugent.be-certificate.yaml')
            .with_content(content)
          }

        end
        context "duplicate name" do
          let(:params) {
            {
              :certname            => 'www.mydomain.com',
              :certpath            => '/etc/ssl/cert',
              :chainpath           => '/etc/ssl/chain',
              :keypath             => '/etc/ssl/key',
              :renew_key           => "true",
              :certtype            => "ssl_multi_domain",
              :ssl_service_name    => "ssl_service",
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
                certificate_file: \"/etc/ssl/cert/www.mydomain.com\"
                certificate_mode: \"0644\"
                certificate_owner: \"root\"
                certificate_group: \"root\"
                certificate_type: \"ssl_multi_domain\"
                chain_file: \"/etc/ssl/chain/www.mydomain.com.chain\"
                chain_mode: \"0644\"
                chain_owner: \"root\"
                chain_group: \"root\"
                renew_key: \"true\"
                ssl_service_name: \"ssl_service\"
                ssl_service_command: \"restarted\"
                key_file: \"/etc/ssl/key/www.mydomain.com.key\"
                key_mode: \"0600\"
                key_owner: \"root\"
                key_group: \"root\""
          it { is_expected.to contain_file('/etc/facter/facts.d/facts-ided.ugent.be-certificate.yaml')
            .with_content(content)
          }
        end
        context "no_common_name_with_san" do
          let(:params) {
            {
              :certname  => 'ided.ugent.be',
              :san_names => 'ided.ugent.be',

            }
          }
          let(:title) { 'other.ugent.be' }

          it { is_expected.to compile.and_raise_error(/You can not have san_names/) }


        end
      end
    end
  end
end
