class supervisor::params {
  case $::osfamily {
    'debian': {
      $conf_file      = '/etc/supervisor/supervisord.conf'
      $conf_dir       = '/etc/supervisor'
      $conf_ext       = '.conf'
      $system_service = 'supervisor'
      $package        = 'supervisor'
    }
    'redhat': {
      $conf_file      = '/etc/supervisord.conf'
      $conf_dir       = '/etc/supervisord.d'
      $conf_ext       = '.conf'
      $system_service = 'supervisord'
      $package        = 'supervisor'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }

  $plugins = ['superlance']
  
  $init_script = "/etc/init.d/$system_service"
}
