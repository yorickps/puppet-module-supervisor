# Class: supervisor
#
# This module manages supervisor
#
# Parameters:
#   @param ensure
#     Ensure if present or absent.
#     Default: present
#
#   @param autoupgrade
#     Upgrade package automatically, if there is a newer version.
#     Default: false
#
#   @param service_ensure
#     Ensure if service is running or stopped.
#     Default: running
#
#   @param service_enable
#     Start service at boot.
#     Default: true
#
#   @param enable_inet_server
#     Enable inet_http_server.
#     Default: false
#
#   @param inet_server_port
#     inet_http_server ip:port to listen on.
#     Only used if inet_http_server is set to true.
#     Default: \*:9000
#
#   @param inet_server_user
#     If set, this is the name of the user to authenticate as.
#     Only used if inet_http_server is set to true.
#     Default: undef
#
#   @param inet_server_pass
#     Password for the inet_http_server.
#     Only used if inet_http_server is set to true and inet_server_user is set.
#     Default: undef
#
#   @param logfile
#     Main log file.
#     Default: /var/log/supervisor/supervisord.log
#
#   @param logfile_maxbytes
#     The maximum number of bytes that may be consumed by the activity log
#     file before it is rotated.
#     Default: 500MB
#
#   @param logfile_backups
#     The number of backups to keep around resulting from activity log
#     file rotation.
#     Default: 10
#
#   @param minfds
#     The minimum number of file descriptors that must be available before
#     supervisord will start successfully.
#     Default: 1024
#
#   @param minprocs
#     The minimum number of process descriptors that must be available before
#     supervisord will start successfully.
#     Default: 200
#
#   @param childlogdir
#     The directory used for AUTO child log files.
#     Default: /var/log/supervisor
#
#   @param user
#     If supervisord is run as the root user, switch users to this UNIX user
#     account before doing any meaningful processing.
#     Default: undef
#
#   @param umask
#     The umask of the supervisord process.
#     Default: 022
#
#   @param supervisor_environment
#     A list of key/value pairs in the form KEY=val,KEY2=val2 that will be
#     placed in the supervisord process environment.
#     Default: undef
#
#   @param identifier
#     The identifier string for this supervisor process,
#     used by the RPC interface.
#     Default: undef
#
#   @param recurse_config_dir
#     Remove unmanaged files from config directory.
#     Default: false
#
# Actions:
#   Installs supervisor.
#
# Sample Usage:
#   class { 'supervisor': }
#
# Notes:
#   You should always invoke the supervisor::service definition instead. Check that readme.
#
class supervisor(
  String $package_ensure,
  Boolean $autoupgrade,
  Enum['running', 'stopped'] $service_ensure,
  Boolean $enable_inet_server,
  String $inet_server_port,
  String $inet_server_user,
  String $inet_server_pass,
  Stdlib::Absolutepath $logfile,
  String $logfile_maxbytes,
  Integer $logfile_backups,
  String $log_level,
  Integer $minfds,
  Integer $minprocs,
  Stdlib::Absolutepath $childlogdir,
  Boolean $nocleanup,
  String $user,
  String $umask,
  String $supervisor_environment,
  String $identifier,
  Boolean $recurse_config_dir,
  Stdlib::Absolutepath $conf_dir,
  String $conf_ext,
  Stdlib::Absolutepath $bin_dir,
  Array $include_files,
  String $file_ensure,
  String $dir_ensure,
  Boolean $service_manage,
  Boolean $service_enable,
  Boolean $service_hasstatus,
  Boolean $service_hasrestart,
) {
  contain supervisor::install
  contain supervisor::config
  contain supervisor::service
  contain supervisor::update

  Class['::supervisor::install']
  -> Class['::supervisor::config']
  ~> Class['::supervisor::service']

}
