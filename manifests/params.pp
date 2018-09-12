# params.pp - define all values

class sslcert::params {

  case $::osfamily {
    'Debian': {
      $certpath = hiera(sslcert::certpath, '/etc/ssl/certs')
      $keypath  = hiera(sslcert::keypath, '/etc/ssl/private')
    }
    'RedHat': {
      $certpath = hiera(sslcert::certpath, '/etc/pki/tls/certs')
      $keypath  = hiera(sslcert::keypath, '/etc/pki/tls/private')
    }
    default: {
      fail("Unsupported OS ${::osfamily}")
    }
  }
  $facts_path = '/etc/facter/facts.d/'
  $facts_path_owner = 'root'
  $facts_path_group = 'root'
  $auto_certificate_renewal_default_enabled = false

}
