# config.pp - provide configfiles

class sslcert::config inherits sslcert {
  
  # define default mode
  File {
    mode  => '0644',
    owner => 'root',
    group => 'root',
  }
  Exec {
    path  => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
  }

  # provide files
  if ($ensure == true) {
    if $sslcert {
      create_resources(sslcert::cert, $sslcert)
    }

  }

}
