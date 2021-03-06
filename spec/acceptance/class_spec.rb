require 'spec_helper_acceptance'

describe 'sslcert class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work after one runs with no errors' do
      write_hiera_config(['default'])
      pp = <<-EOS
      class { '::sslcert':;}
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    certpath = ''
    keypath = ''
    case fact('osfamily')
    when 'Debian'
      certpath = '/etc/ssl/certs/'
      keypath  = '/etc/ssl/private/'
    when 'RedHat'
      certpath = '/etc/pki/tls/certs/'
      keypath  = '/etc/pki/tls/private/'
    end


    describe file(certpath + 'www.myhost.com') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should match '-----BEGIN CERTIFICATE-----
MIICwDCCAaigAwIBAgIJANhNYlzhJJOtMA0GCSqGSIb3DQEBCwUAMBgxFjAUBgNV
BAMMDWRlYmlhbi04Mi14NjQwHhcNMTYwNjIwMTAyODM3WhcNMjYwNjE4MTAyODM3
WjAYMRYwFAYDVQQDDA1kZWJpYW4tODIteDY0MIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAwqpMG3m7MMFU6Rswl9Ls5Y8POdM5ENR1t95+VtIhU3jbiUMW
VUu7zjZvUqVcXm3p7eyHD7EoQofAcbUSk385wgAABN3Ct8eyO7VHeloigpQHfmbY
7o79ajCI0Y99VJqVg0hwCvfnK8xD+EAPD6rd/U9EFfMqSVEzEZBTRM/WedBB8u5l
ZMrQ845UocX2rIZ4E+fEmWEhs0J+ruhUBlv+8QhH1x5KvRzaBIILKwV4VPBRFlmY
1o+KigEjaUhbSSnce9NX453oDxZiYgtBch7py0a43OYvL3KaDo5lmcC3L50iIcn+
ROu5N6E4zrWbGdOtYyEuu8O6ikkXG+F2S6K/gwIDAQABow0wCzAJBgNVHRMEAjAA
MA0GCSqGSIb3DQEBCwUAA4IBAQB/f5HBdGYfdUmuwGJ99Letlh2PjXEZHLjzNuPo
GeIA/OG/DmyrzVqR7L0B4AuTpexzntDynHuh6d7iH8tTCiTZ1wVn/giS9/hATrui
N9xZTY0kKiRfEJydXAOIEd4i4hjH2rVDdbfGK7XbJ8Y5pejookW9L0s8vdjGP6l1
H4dwo/NT6bQWqreykNcU5uNZSW9/3JjXSazKwUePPZpt5+x06iddTEiJlmNzTSaB
k574U4LAExPi1SfSaZMvHcNmVKwlcLfCFwXrX4q7tqjMcc7yEZkJgkkJnWJtDqYa
oFTsD8vCIFgRL1aM0GBEf0tTHdIjrniD7uaxIrfU2kgSHna0
-----END CERTIFICATE-----
' }
    end

    describe file(keypath + 'www.myhost.com.key') do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'adm' }
      its(:content) { should match '-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCqkwbebswwVTp
GzCX0uzljw850zkQ1HW33n5W0iFTeNuJQxZVS7vONm9SpVxebent7IcPsShCh8Bx
tRKTfznCAAAE3cK3x7I7tUd6WiKClAd+Ztjujv1qMIjRj31UmpWDSHAK9+crzEP4
QA8Pqt39T0QV8ypJUTMRkFNEz9Z50EHy7mVkytDzjlShxfashngT58SZYSGzQn6u
6FQGW/7xCEfXHkq9HNoEggsrBXhU8FEWWZjWj4qKASNpSFtJKdx701fjnegPFmJi
C0FyHunLRrjc5i8vcpoOjmWZwLcvnSIhyf5E67k3oTjOtZsZ061jIS67w7qKSRcb
4XZLor+DAgMBAAECggEAMqECHF9DvUF7KQmGUOZt8KKNjjeObv8jAsheSYxrWH9l
ccS+CT8iQFbOC0uww2qI3fWXhxBHbU5LUgeLJkt/pSJE3v8iRpQsmfTi+0J4GUgQ
zuJG53zPEhA/dWmBakCuRC/R3Dhvqmd9AhL/F88T327/QUo2JE13H8lOruXzXUjE
+m6zS3GGqs6awaS7QpvKtQ5PX4ybyqqh8p/H8SJDOQR5U8OijJQ5lws7rqrDs8kU
3vWxtdlt0EgIr0FlBPRoYcdqL3QVDW1BsoekUdG74M1kXmjXQcnnzpxRZtZDEsZs
tSdfS4hHRG6ev2Mb4B6VTGXiUm/Y8u5bWA+IZAPqUQKBgQD7l9Ia8D6MxEUtOBSz
7Sh+Xo3ayPQ408PflbbgOE/FYLvM98fXcpIelrTkovJcYz1Gp5FWmLfuM42qNIrx
/FdpU6VS0a4PtcHKZ06+k5HSFOyhkzu4FQcNcBPUIvUKlxzGOaroo44lwKSW7t2O
L1syMt2j71NFnDvgQu7V9/XM6QKBgQDGEzQ8Pry/CSIcZnDj9QOw6cwsBTPkZKmN
QHy0U/wWylJsHr+vK0K2kt7/TaD1bU8+hKvsOB4s4rOPceV2iqoHSYZwBdev1bqO
ZoXrThT5hBQ8FmM8HSaxZJvCmqay19RO78PSaAtN+dWrj8OyF5iV8BHReTdRhKxa
JqiD8pZ1iwKBgQDbHZVh2rxPMpygzkfRkAmFTWo0EnIIj/32WtiDnOd0mlPVJjNI
40J5G3395iA38EIsp8G/bpA6B3Iou0wLhl7Gn4/Lekwi6IQXeDOvbKxCD/EqoyUO
pFmZDXRne+53w7XOueisZc1l+coenXgd3gaJyJ0ZqlSWuoO3Q/PoK+VKCQKBgDNl
3FIdvYCc8BsKghTFCXYo1PA/UV3cuRqMN0/b0zheu9COkhL0WNVjezYogLHu8Xc5
mhsr3LitAwcf+Pkvtjs52wbKnVNlVImLFQkgM9UjbtTAwnNg5R93CewPkV4rH050
bQ32LajIQafJIHDgKpoNt7HxkGc41Dh4e5XxpxVNAoGAVeS8c7ehgCSSvKvbqnj6
tcJaKzloslOUj5d72kld27DLwuhfp8skkDsgTzQah3ayip0V915BMS3804fiTPgQ
va09I/gRtb6lfd3jXzPR0JE4l/OX5VygSST9ZvoThan6VjZ8Hq4tsBjZLB34z1bt
4dg0vkClSfJrA2rBFtYPKAk=
-----END PRIVATE KEY-----
' }
    end

    describe file(certpath + 'www.myhost.com.chain') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should match 'some chain text' }
    end

    describe file(certpath + 'www.myhost.com.csr') do
      it { should_not exist }
    end
  end
end
