# config.pp - provide configfiles

class sslcert::config inherits sslcert {

  ensure_packages('openssl')

  # deploy files
  if ($sslcert::ensure == true) {
    if $sslcert::certificates {
      create_resources(sslcert::cert, $sslcert::certificates)
    }
  }

}
