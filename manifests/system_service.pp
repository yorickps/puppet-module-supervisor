# == Class supervisor::service
#
# This class is meant to be called from supervisor.
# It ensure the service is running.
#
class supervisor::system_service {
  if $supervisor::system_service_manage == true {
    systemd::unit_file { "${supervisor::system_service}.service":
      content => epp("${module_name}/supervisor.service.epp"),
      enable  => $supervisor::system_service_enable,
      active  => $supervisor::system_service_active,
      require => File[$supervisor::conf_file],
    }
  }
}
