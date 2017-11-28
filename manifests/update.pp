class supervisor::update {
  exec { 'supervisor::update':
    command     => "${supervisor::bin_dir}/supervisorctl update",
    logoutput   => on_failure,
    refreshonly => true,
    require     => Service[$supervisor::params::system_service],
  }
}
