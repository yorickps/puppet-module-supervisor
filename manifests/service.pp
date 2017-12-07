# Actions:
#   Set up a daemon to be run by supervisor
#
# Sample Usage:
#  supervisor::service { 'organizational_worker':
#    command         => '/usr/bin/php /var/www/vhosts/site/gearman/worker.php',
#    numprocs        => 2,
#    numprocs_start  => 1,
#    user            => 'org_user',
#    group           => 'org_group',
#  }
#
define supervisor::service (
  $command,
  $ensure                   = present,
  $enable                   = true,
  $numprocs                 = 1,
  $numprocs_start           = 0,
  $priority                 = 999,
  $autorestart              = 'unexpected',
  $startsecs                = 1,
  $retries                  = 3,
  $exitcodes                = '0,2',
  $stopsignal               = 'TERM',
  $stopwait                 = 10,
  $user                     = 'root',
  $group                    = 'root',
  $redirect_stderr          = false,
  $directory                = undef,
  $stdout_logfile           = undef,
  $stdout_logfile_maxsize   = '250MB',
  $stdout_logfile_keep      = 10,
  $stderr_logfile           = undef,
  $stderr_logfile_maxsize   = '250MB',
  $stderr_logfile_keep      = 10,
  $environment              = undef,
  $umask                    = undef,
  $process_group            = undef
) {
  include supervisor

  case $ensure {
    absent: {
      $autostart = false
      $dir_ensure = 'absent'
      $dir_recurse = true
      $dir_force = true
      $service_ensure = 'stopped'
      $config_ensure = 'absent'
    }
    present: {
      $autostart = true
      $dir_ensure = 'directory'
      $dir_recurse = false
      $dir_force = false
      $service_ensure = 'running'

      if $enable == true {
        $config_ensure = undef
      } else {
        $config_ensure = absent
      }
    }
    default: {
      fail("ensure must be 'present' or 'absent', not ${ensure}")
    }
  }

  file { "/var/log/supervisor/${name}":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    recurse => $dir_recurse,
    force   => $dir_force,
    require => Class['supervisor'],
  }

  file { "${supervisor::conf_dir}/${name}${supervisor::conf_ext}":
    ensure  => $config_ensure,
    content => template('supervisor/service.ini.erb'),
    require => File["/var/log/supervisor/${name}"],
    notify  => Class['supervisor::update'],
  }

  $process_name = $process_group ? {
    undef   => $name,
    default => "${process_group}:${name}"
  }

  $allprocs = $numprocs > 1 {
    false => '',
    true  => ':*'
  }

  service { "supervisor::${name}":
    ensure   => $service_ensure,
    provider => base,
    restart  => "${supervisor::bin_dir}/supervisorctl restart ${process_name}${allprocs} | awk '/^(.*?:)?${name}/{print \$2}' | grep -Pzo '^started$'",
    start    => "${supervisor::bin_dir}/supervisorctl start ${process_name} | grep 'started'",
    status   => "${supervisor::bin_dir}/supervisorctl status | awk '/^(.*?:)?${name}/{print \$2}' | grep '^RUNNING$'",
    stop     => "${supervisor::bin_dir}/supervisorctl stop ${process_name}${allprocs} | awk '/^(.*?:)?${name}/{print \$2}' | grep '^stopped$'",
    require  => [Class['supervisor::update'], File["${supervisor::conf_dir}/${name}${supervisor::conf_ext}"]],
  }
}
