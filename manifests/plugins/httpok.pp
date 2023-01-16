# @summary 
#   This configures the httpok plugin
# @param address
#   Address of the web app to check
# @param port 
#   Port to check
# @param url 
#   Http url to check on the address
# @param code 
#   Http status code to check
# @param numprocs 
#   Supervisor will start as many instances of this program as named by numprocs
define supervisor::plugins::httpok (
  Stdlib::Httpurl $address,
  Stdlib::Port $port,
  String $url,
  Integer $code     = 200,
  Integer $numprocs = 1,
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
