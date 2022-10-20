# == Class supervisor::service
#
# This class is meant to be called from supervisor.
# It ensure the service is running.
#
class supervisor::system_service {
  if $supervisor::system_service_manage == true {
    service { $supervisor::system_service:
      ensure     => $supervisor::system_service_ensure,
      enable     => $supervisor::system_service_enable,
      hasstatus  => $supervisor::system_service_hasstatus,
      hasrestart => $supervisor::system_service_hasrestart,
      require    => [
      File[$supervisor::conf_file],
      File[$supervisor::init_script],
      ],
    }
  }
}
