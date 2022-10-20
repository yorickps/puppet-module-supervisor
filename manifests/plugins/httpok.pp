define supervisor::plugins::httpok (
  $address,
  $port,
  $url,
  $code     = 200,
  $numprocs = 1,
) {
  $ports = range ($port, $port + $numprocs - 1)

  if $numprocs > 1 {
    $process_prefix = "${title}:${title}_"
  } else {
    $process_prefix = $title
  }

  file { "${supervisor::conf_dir}/httpok-${title}.conf":
    ensure  => $supervisor::file_ensure,
    content => template('supervisor/plugins/httpok.ini.erb'),
    require => File[$supervisor::conf_dir],
    notify  => Service[$supervisor::system_service],
  }
}
