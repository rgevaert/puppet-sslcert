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
  }

}
