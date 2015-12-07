# cert.pp - create certificates and keys

define sslcert::cert (
  $certpath = $sslcert::certpath,
  $certname,
  $owner    = 'root',
  $group    = 'root',
  $mode     = '0644',
  $cert,
  $keypath  = $sslcert::keypath,
  $keyname  = undef,
  $keyowner = undef,
  $keygroup = undef,
  $keymode  = undef,
  $key      = undef,
) { 

  file { "${certpath}/${certname}":
    content => $cert,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }

  if $key {
    $keyfile = $keyname ? {
      undef   => $certname,
      default => $keyname,
    }
    file { "${keypath}/${keyfile}":
      content => $key,
      owner   => $keyowner ? {
        undef   => $owner,
        default => $keyowner,
      },
      group   => $keygroup ? {
        undef   => $group,
        default => $keygroup,
      },
      mode    => $keymode ? {
        undef   => '0600',
        default => $keymode,
      },
    }
  }

}
