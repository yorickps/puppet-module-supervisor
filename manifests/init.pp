# Class: supervisor
#
#  @summary
#    This module manages supervisor
#
# Parameters:
#   @param package
#     Supervisor package name - to install
#
#   @param package_ensure
#     Whether or not to install supervisor package
#     Default: true
#
#   @param package_manage
#     Manage Supervisor package or not
#     Default: true
#
#   @param package_provider
#     Provider to install package
#     Default: pip
#
#   @param ensure
#     Ensure if present or absent.
#     Default: present
#
#   @param autoupgrade
#     Upgrade package automatically, if there is a newer version.
#     Default: false
#
#   @param system_service_ensure
#     Ensure if service is running or stopped.
#     Default: running
#
#   @param system_service_enable
#     Start service at boot.
#     Default: true
#
#   @param system_service
#     Service name
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
#   @param plugins
#     Array of plugins to install
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
class supervisor (
  Boolean $autoupgrade,
  Stdlib::Absolutepath $bin_dir,
  Stdlib::Absolutepath $childlogdir,
  Stdlib::Absolutepath $conf_dir,
  String $conf_ext,
  Stdlib::Absolutepath $conf_file,
  String $dir_ensure,
  Boolean $enable_inet_server,
  String $file_ensure,
  Optional[String] $identifier,
  Array $include_files,
  Optional[String] $inet_server_pass,
  Optional[String] $inet_server_port,
  Optional[String] $inet_server_user,
  Stdlib::Absolutepath $init_script,
  String $log_level,
  Stdlib::Absolutepath $logfile,
  Integer $logfile_backups,
  String $logfile_maxbytes,
  Integer $minfds,
  Integer $minprocs,
  Boolean $nocleanup,
  String $package,
  String $package_ensure,
  Array $package_install_options,
  Boolean $package_manage,
  String $package_provider,
  Array $plugins,
  Boolean $recurse_config_dir,
  Optional[Hash] $service,
  Optional[String] $supervisor_environment,
  String $system_service,
  Boolean $system_service_active,
  Boolean $system_service_enable,
  Boolean $system_service_manage,
  String $umask,
  Optional[String] $user,
  Optional[Boolean] $user_manage
) {
  contain supervisor::install
  contain supervisor::config
  contain supervisor::system_service
  contain supervisor::update

  Class['supervisor::install']
  -> Class['supervisor::config']
  ~> Class['supervisor::system_service']
}
