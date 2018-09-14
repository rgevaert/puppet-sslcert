# init.pp - main manifest

class sslcert (

  $ensure       = hiera(sslcert::ensure, true),
  $certificates = hiera_hash(sslcert::certificates, undef),
  $certpath     = $sslcert::params::certpath,
  $keypath      = $sslcert::params::keypath,
  $auto_certificate_renewal = $sslcert::params::auto_certificate_renewal_default_enabled,
  $chainenabled = $sslcert::params::chainenabled,

) inherits sslcert::params {

  include ::sslcert::config


  file { '/etc/facter/facts.d/facts-certificate-autorenew.yaml':
    ensure  => present,
    path    => '/etc/facter/facts.d/facts-certificate-autorenew.yaml',
    content => template('sslcert/certificate_autorenewal_feature.yaml.erb'),
  }
}
