# init.pp - main manifest

class sslcert (
  $ensure            = hiera(sslcert::ensure, true),
  $sslcert           = hiera_hash(sslcert::sslcert, undef),
  $path              = $sslcert::params::path,
) inherits sslcert::params {

  include sslcert::config

}
