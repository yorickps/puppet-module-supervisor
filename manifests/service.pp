#
# @summary Service defintion
#
# @param command 
#   Command to run
# @param ensure 
#   Ensure service. Default: present
# @param enable 
#   Enable service. Default: true
# @param numprocs
#   Number of procs to run. Default: 1
# @param numprocs_start
#   An integer offset that is used to compute the number at which process_num starts. Default: 0
# @param priority
#   The relative priority of the program in the start and shutdown ordering. Default: 999
# @param autorestart
#   Specifies if supervisord should automatically restart a process if it exits when it is in the RUNNING state. Default: unexpected
# @param startsecs
#   The total number of seconds which the program needs to stay running after a startup to consider the start successful
# @param retries 
#   The number of serial failure attempts that supervisord will allow when attempting to start the program before giving up and putting the process into an FATAL state.
# @param exitcodes
#   The list of "expected" exit codes for this program used with autorestart
# @param stopsignal
#   The signal used to kill the program when a stop is requested. Default: TERM
# @param stopwait
#   The number of seconds to wait for the OS to return a SIGCHLD to supervisord after the program has been sent a stopsigna. Default: 10
# @param user
#   Instruct supervisord to use this UNIX user account as the account which runs the program
# @param group
#
# @param redirect_stderr
#   If true, cause the process' stderr output to be sent back to supervisord on its stdout file descriptor 
# @param directory
# 
# @param stdout_logfile
#   Put process stdout output in this file
# @param stdout_logfile_keep
#   The number of stdout_logfile backups to keep around resulting from process stdout log file rotation. Default: 10
# @param stdout_logfile_maxsize
#   The maximum number of bytes that may be consumed by stdout_logfile. Default: 250MB
# @param stderr_logfile
#   Put process stderr output in this file. Default: false
# @param stderr_logfile_keep
#   The number of sterr_logfile backups to keep around resulting from process stdout log file rotation. Default: 10
# @param stderr_logfile_maxsize
#   The maximum number of bytes that may be consumed by stderr_logfile. Default: 250MB
# @param environment
#   A list of key/value pairs in the form KEY="val",KEY2="val2" that will be placed in the child process’ environment. 
# @param umask
#   An octal number (e.g. 002, 022) representing the umask of the process. Default: undef
# @param process_group
#   
#
# Actions:
#   Set up a daemon to be run by supervisor
#
define supervisor::service (
  String $command,
  String $ensure                 = present,
  Boolean $enable                = true,
  Integer $numprocs              = 1,
  Integer $numprocs_start        = 0,
  Integer $priority              = 999,
  String $autorestart            = 'unexpected',
  Integer $startsecs             = 1,
  Integer $retries               = 3,
  String $exitcodes              = '0,2',
  String $stopsignal             = 'TERM',
  Integer $stopwait              = 10,
  String $user                   = 'root',
  String $group                  = 'root',
  Boolean $redirect_stderr       = false,
  Optional[Stdlib::Absolutepath] $directory = undef,
  Stdlib::Absolutepath $stdout_logfile      = undef,
  String $stdout_logfile_maxsize            = '250MB',
  Integer $stdout_logfile_keep              = 10,
  Stdlib::Absolutepath $stderr_logfile      = undef,
  String $stderr_logfile_maxsize            = '250MB',
  Integer $stderr_logfile_keep              = 10,
  Optional[String] $environment             = undef,
  Optional[String] $umask                   = undef,
  Optional[String] $process_group           = undef
) {
  case $ensure {
    'absent': {
      $autostart = false
      $dir_ensure = 'absent'
      $dir_recurse = true
      $dir_force = true
      $service_ensure = 'stopped'
      $config_ensure = 'absent'
    }
    'present': {
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
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    recurse => $dir_recurse,
    force   => $dir_force,
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

  $allprocs = ($numprocs > 1) ? {
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
    notify   => Class['supervisor::update'],
  }
}
