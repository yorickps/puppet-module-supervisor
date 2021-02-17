# == Class supervisor::service
#
# This class is meant to be called from supervisor.
# It ensure the service is running.
#
class supervisor::service {
  if $supervisor::service_manage == true {
    service { $supervisor::system_service:
      ensure     => $supervisor::service_ensure,
      enable     => $supervisor::service_enable,
      hasstatus  => $supervisor::service_hasstatus,
      hasrestart => $supervisor::service_hasrestart,
      require    => [
      File[$supervisor::conf_file],
      File[$supervisor::init_script],
      ],
    }
  }
}
