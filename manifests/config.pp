# @summary
#   This class handles the configuration files and related settings.
#
# @api private
#
class supervisor::config {
  file { $supervisor::conf_dir:
    ensure  => $supervisor::dir_ensure,
    purge   => true,
    recurse => $supervisor::recurse_config_dir,
    require => Package[$supervisor::package],
  }

  file { [
      '/var/log/supervisor',
      '/var/run/supervisor',
    ]:,
    ensure  => $supervisor::dir_ensure,
    purge   => true,
    backup  => false,
    require => Package[$supervisor::package],
  }

  file { $supervisor::conf_file:
    ensure  => $supervisor::file_ensure,
    content => epp('supervisor/supervisord.conf.epp'),
    require => File[$supervisor::conf_dir],
  }

  file { '/etc/logrotate.d/supervisor':
    ensure  => $supervisor::file_ensure,
    source  => 'puppet:///modules/supervisor/logrotate',
    require => Package[$supervisor::package],
  }

#  file { $supervisor::init_script:
#    ensure   => $supervisor::file_ensure,
#    mode     => '0755',
#    template => epp('supervisor/supervisor.service.epp'),
#    notify   => Service[$supervisor::system_service],
#  }
}
