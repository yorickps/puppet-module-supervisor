# @summary
#   This class handles the configuration files and related settings.
#
# @api private
#
class supervisor::config {
  if $supervisor::user_manage == true {
    user { $supervisor::user:
      ensure => present,
    }
  }

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

  # create all the individual services defined
  $supervisor::service.each |String $key, Hash $attrs| {
    supervisor::service { $key:
      * => $attrs,
    }
  }
}
