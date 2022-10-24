# @summary
#   This class handles package/plugins installation.
#
# @api private
#
class supervisor::install {
  if $supervisor::package_manage == true {
    ensure_packages($supervisor::package, {
        ensure          => $supervisor::package_ensure,
        install_options => $supervisor::package_install_options,
        provider        => $supervisor::package_provider,
    })
  }

  ensure_packages($supervisor::plugins, {
      ensure          => $supervisor::package_ensure,
      install_options => $supervisor::package_install_options,
      provider        => $supervisor::package_provider,
      require         => Package[$supervisor::package]
  })
}
