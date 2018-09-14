# cert.pp - create certificates and keys

define sslcert::cert (
  $certname,
  $ensure              = 'present',
  $csr                 = '', # not used, don't ask
  $cert                = '', # actual cert
  $certpath            = $::sslcert::certpath,# backward compatiblity (directory)
  $certfile            = '', # complete path of file (dir+file)
  $certowner           = undef, # default same as owner
  $certgroup           = undef, # default same as group
  $certmode            = undef, # default same as mode
  $certtype            = '', # needed for digicert request
  $chain               = '', # actual chain
  $chainpath           = $::sslcert::certpath, #backward compatiblity (directory)
  $chainfile           = '', # complete path of file (dir+file)
  $chainowner          = undef, # default same as owner
  $chaingroup          = undef, # default same as group
  $chainmode           = undef, # default same as mode
  $chainenabled        = $::sslcert::chainenabled,
  $common_name         = '', # ex. something.com
  $san_names           = '', # comma seperated list, common_name is required for this
  $ssl_service_name    = '', # ex. apache
  $ssl_service_command = '', # ex. restarted
  $owner               = 'root', # default value for key,chain,cert
  $group               = 'root', # default value for key,chain,cert
  $mode                = '0644', # default value for chain,cert
  $keypath             = $::sslcert::keypath, # backward compatiblity (directory)
  $keyfile             = '', # complete path of file (dir+file)
  $keyname             = undef, # default certname
  $keyowner            = undef, # default same as owner
  $keygroup            = undef, # default same as group
  $keymode             = undef, # default value 0600
  $key                 = '', # actual key
  $renew_key           = '', # force key renewal with cert request
) {

  require '::sslcert'

  if ( $common_name == '' and $san_names != '' ){
    fail("Sslcert::cert You can not have san_names (${san_names}) with empty common name ")
  }

  $key_owner = $keyowner ? {
    undef   => $owner,
    default => $keyowner,
  }
  $key_group = $keygroup ? {
    undef   => $group,
    default => $keygroup,
  }
  $key_mode =  $keymode ? {
    undef   => '0600',
    default => $keymode,
  }

  $key_file = $keyfile ? {
    '' => $keyname ? {
      undef   => "${keypath}/${certname}.key",
      default => "${keypath}/${keyname}",
    },
    default => $keyfile,
  }

  if $key != '' {
    file { $key_file:
      ensure    => $ensure,
      show_diff => false,
      content   => $key,
      owner     => $key_owner,
      group     => $key_group,
      mode      => $key_mode,
    }
  }


  $chain_owner = $chainowner ? {
    undef      => $owner,
    default    => $chainowner
  }
  $chain_group = $chaingroup ? {
    undef   => $group,
    default => $chaingroup,
  }
  $chain_mode =  $chainmode ? {
    undef   => $mode,
    default => $chainmode,
  }

  $chain_file = $chainfile ? {
    '' => $chainname ? {
      undef   => "${chainpath}/${certname}.chain",
      default => "${chainpath}/${chainname}",
    },
    default => $chainfile,
  }

  if $chain != '' {
    file { $chain_file:
      ensure  => present,
      content => $chain,
      owner   => $chain_owner,
      group   => $chain_group,
      mode    => $chain_mode,
    }
  }

  $certificate_owner = $certowner ? {
    undef      => $owner,
    default    => $certowner
  }
  $certificate_group = $certgroup ? {
    undef   => $group,
    default => $certgroup,
  }
  #backward compatibility
  $certificate_mode =  $certmode ? {
    undef   => $mode,
    default => $certmode,
  }
  #needed for facts
  $certificate_type = $certtype

  $certificate_file = $certfile ? {
    '' => $certname ? {
      undef   => "${certpath}/${certname}",
      default => "${certpath}/${certname}",
    },
    default => $certfile,
  }


  if $cert != '' {
    file { $certificate_file:
      ensure  => $ensure,
      content => $cert,
      owner   => $certificate_owner,
      group   => $certificate_group,
      mode    => $certificate_mode,
    }
  }



  #facts using variables from above
  file { "/etc/facter/facts.d/facts-${name}-certificate.yaml":
    ensure  => $ensure,
    content => template('sslcert/certificate_autorenewal_configuration.yaml.erb'),
  }
}
