# Class: supervisor
#
#  @summary
#    This module manages supervisor
#
# Parameters:
#
#   @param autoupgrade
#     Upgrade package automatically, if there is a newer version.
#     Default: false
#
#   @param bin_dir
#     Supervisord binary dir location. Supervisord gets installed through python-pip.
#
#   @param childlogdir
#     The directory used for AUTO child log files.
#     Default: /var/log/supervisor
#
#   @param chmod
#     Boolean to manage chmod.
#     Default: false
#
#   @param chown
#     Boolean to manage chown.
#     Default: false
#
#   @param conf_dir
#     Config dir location
#
#   @param conf_ext
#     Extension of the config file to load. Default: '.conf '
#
#   @param conf_file
#     Location of the supervisord main configuration file. Default: ~ (see data/ per OS)
#
#   @param dir_ensure
#     Manage the config directory. Default: directory
#
#   @param enable_inet_server
#     Enable inet_http_server.
#     Default: false
#
#   @param file_ensure
#     Manage the config file presence. Default: present
#
#   @param identifier
#     The identifier string for this supervisor process,
#     used by the RPC interface.
#     Default: undef
#
#   @param include_files
#     Array to include additional config files. Default: []
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
#   @param init_script
#     Location of the init script / systemd service file. Default: "/etc/systemd/system/%{lookup($supervisor::system_service)}"
#
#   @param log_level
#     Log level. Default: info
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
#   @param nocleanup
#     Prevent supervisord from clearing any existing AUTO child log files at startup time. Useful for debugging. Default: false
#
#   @param package
#     Supervisor package name - to install
#
#   @param package_ensure
#     Whether or not to install supervisor package
#     Default: true
#
#   @param package_install_options
#     Install options for the supervisor package. E.g. enable / disable certain package repositories. Default: []
#
#   @param package_manage
#     Manage Supervisor package or not
#     Default: true
#
#   @param package_provider
#     Provider to install package
#     Default: pip
#
#   @param plugins
#     Array of plugins to install
#
#   @param recurse_config_dir
#     Remove unmanaged files from config directory.
#     Default: false
#
#   @param service
#     Hash to define the supervisor services you would like to define / manage. Default: {}
#
#   @param supervisor_environment
#     A list of key/value pairs in the form KEY=val,KEY2=val2 that will be
#     placed in the supervisord process environment.
#     Default: undef
#
#   @param system_service
#     Service name
#
#   @param system_service_active
#     Ensure if service is active or not.
#     Default: true
#
#   @param system_service_enable
#     Start service at boot.
#     Default: true
#
#   @param system_service_manage
#     Whether or not to manage the supervisord system service. Default: true
#
#   @param umask
#     The umask of the supervisord process.
#     Default: 022
#
#   @param user
#     If supervisord is run as the root user, switch users to this UNIX user
#     account before doing any meaningful processing.
#     Default: undef
#
#   @param user_manage
#     Whether or not to install and manage the supervisor user. Default: false
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
  Optional[Boolean] $chmod,
  Optional[Boolean] $chown,
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
