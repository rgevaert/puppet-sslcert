# cert.pp - sslcert define

define sslcert::cert (
  $path  = "$sslcert::path",
  $file  = 'server.crt',
  $owner = 'root',
  $group = 'root',
  $mode  = '0440',
  $key   = undef,
) { 

  file { "$path/$file":
    content => template("$module_name/cert.erb"),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }

}
