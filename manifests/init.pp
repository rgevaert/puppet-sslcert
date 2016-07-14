# init.pp - main manifest

class sslcert (

  $ensure       = hiera(sslcert::ensure, true),
  $certificates = hiera_hash(sslcert::certificates, undef),
  $certpath     = $sslcert::params::certpath,
  $keypath      = $sslcert::params::keypath,

) inherits sslcert::params {

  include ::sslcert::config

}
