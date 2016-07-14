# cert.pp - create certificates and keys

define sslcert::cert (
  $certname,
  $ensure   = 'present',
  $csr      = '',
  $certpath = $sslcert::certpath,
  $chain    = undef,
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
      ensure    => present,
      show_diff => false,
      content   => $key,
      owner     => $keyowner ? {
        undef   => $owner,
        default => $keyowner,
      },
      group     => $keygroup ? {
        undef   => $group,
        default => $keygroup,
      },
      mode      => $keymode ? {
        undef   => '0600',
        default => $keymode,
      },
    }
  } else {
    file { "${keypath}/${keyfile}":
      ensure => absent,
    }
  }

  if $ensure == 'present' and $chain != '' {
    file { "${certpath}/${certname}.chain":
      ensure  => present,
      content => $chain,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }
  } else {
    file { "${certpath}/${certname}.chain":
      ensure  => absent,
    }
  }

}
