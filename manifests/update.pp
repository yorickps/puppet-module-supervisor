# @summary
#   This class handles the update of supervisor managed services.
#
# @api private
#
class supervisor::update {
  exec { 'supervisor::update':
    command     => "${supervisor::bin_dir}/supervisorctl update",
    logoutput   => on_failure,
    refreshonly => true,
    require     => Systemd::Unit_file["${supervisor::system_service}.service"],
  }
}
