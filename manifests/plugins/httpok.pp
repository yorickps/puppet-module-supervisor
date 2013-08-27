define supervisor::plugins::httpok (
  $url,
  $port,
  $code     = 200,
  $numprocs = 1,

) {

  $ports = range ($port, $port + $numprocs - 1)

  if $numprocs > 1 {
    $process_prefix = "${title}:${title}_"
  } else {
    $process_prefix = $title
  }

  file { "${supervisor::params::conf_dir}/httpok-${title}.conf":
    ensure  => $file_ensure,
    content => template('supervisor/plugins/httpok.ini.erb'),
    require => File[$supervisor::params::conf_dir],
    notify  => Service[$supervisor::params::system_service],
  }
}