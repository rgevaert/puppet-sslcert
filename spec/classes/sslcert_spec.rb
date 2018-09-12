require 'spec_helper'

describe 'sslcert' do
  context "default" do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        context "sslcert" do

          it { is_expected.to compile.with_all_deps }
          content = "# Managed by Puppet
# puppet-sslcert
---
auto_cert_renewal_enabled: \"false\"
"
          it { is_expected.to contain_file('/etc/facter/facts.d/facts-certificate-autorenew.yaml')
            .with_content(content)
           }
        end
      end
    end
  end

end
