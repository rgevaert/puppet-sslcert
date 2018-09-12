# cert.pp - create certificates and keys

define sslcert::cert (
  $certname,
  $ensure              = 'present',
  $csr                 = '',
  $certpath            = $sslcert::certpath,
  $certificate_file    = '',
  $certificate_type    = '',
  $chain               = '',
  $chainpath           = '',
  $chain_file          = '',
  $common_name         = '',
  $san_names           = '',
  $ssl_service_name    = '',
  $ssl_service_command = '',
  $owner               = 'root',
  $group               = 'root',
  $mode                = '0644',
  $cert                = '',
  $keypath             = $sslcert::keypath,
  $keyname             = undef,
  $keyowner            = undef,
  $keygroup            = undef,
  $keymode             = undef,
  $key                 = '',
  $renew_key           = '',
) {

  file { "/etc/facter/facts.d/facts-${certname}-certificate.yaml":
    ensure  => $ensure,
    content => template('sslcert/certificate_autorenewal_configuration.yaml.erb'),
  }


  if $cert != '' {
    file { "${certpath}/${certname}":
      ensure  => $ensure,
      content => $cert,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }
  }

  $keyfile = $keyname ? {
    undef   => "${certname}.key",
    default => $keyname,
  }
  if $key != '' {
    file { "${keypath}/${keyfile}":
      ensure    => $ensure,
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
  }

  if $chainpath == '' {
    $internal_chainpath = "${certpath}/${certname}.chain"
  }else {
    $internal_chainpath = $chainpath
  }

  if $chain != '' {
    file { $internal_chainpath:
      ensure  => present,
      content => $chain,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }
  }

}
