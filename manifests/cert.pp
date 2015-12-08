# cert.pp - create certificates and keys

define sslcert::cert (
  $ensure   = 'present',
  $certpath = $sslcert::certpath,
  $certname,
  $owner    = 'root',
  $group    = 'root',
  $mode     = '0644',
  $cert     = '',
  $keypath  = $sslcert::keypath,
  $keyname  = undef,
  $keyowner = undef,
  $keygroup = undef,
  $keymode  = undef,
  $key      = '',
) { 

  if $ensure == 'present' and $cert != '' {
    file { "${certpath}/${certname}":
      ensure  => present,
      content => $cert,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }
  } else {
    file { "${certpath}/${certname}":
      ensure  => absent,
    }
  }

  $keyfile = $keyname ? {
    undef   => "${certname}.key",
    default => $keyname,
  }
  if $ensure == 'present' and $key != '' {
    file { "${keypath}/${keyfile}":
      ensure  => present,
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
  } else {
    file { "${keypath}/${keyfile}":
      ensure => absent,
    }
  }

}
