define supervisor::plugins::httpok (
  $process,
  $httpok_url,
  $httpok_code = 200,
) {

  file { "${supervisor::params::conf_dir}/httpok-${process}.conf":
    ensure  => $file_ensure,
    content => template('supervisor/plugins/httpok.ini.erb'),
    require => File[$conf_dir],
    notify  => Service[$supervisor::params::system_service],
  }
}