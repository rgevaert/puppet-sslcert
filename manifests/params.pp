# params.pp - define all value

class sslcert::params {

  case $::osfamily {
    'Debian': {
      $path         = hiera(sslcert::path, '/etc/ssl/certs')
    }
    'RedHat': {
      $path         = hiera(sslcert::path, '/etc/pki/tls/certs')
    }
  }

}
