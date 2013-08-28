Puppet module for configuring the 'supervisor' daemon control
utility. Currently tested on CentOS 6.

This fork installs using pip rather than system packages, since CentOS supervisor packages are hopelessly out-of-date. I've also added 
some support for supervisor extensions (specifically superlance/httpok, but can easily be extended).

Install into `<module_path>/supervisor`

Example usage:

.. code-block:: puppet

  include supervisor

  supervisor::service { 'http-app':
    ensure          => present,
    enable          => true,
    user            => 'http-user',
    directory       => '/var/www/http-app',
    numprocs        => 4,
    numprocs_start  => 8000,
    command         => "/var/www/http-app/app.py --host 127.0.0.1 --port %(process_num)s",
    redirect_stderr => true,
    stdout_logfile  => "/var/log/supervivor/http-app-%(process_num)s.log",
    stderr_logfile  => "/var/log/supervisor/http-app-%(process_num)s.error.log"
  }

  supervisor::plugins::httpok { 'http-app':
    url      => 'http://127.0.0.1',
    port     => 8000,
    code     => '200',
    numprocs => 4
  }

Running tests:

.. code-block:: sh

  $ bundle install --path=.gems
  $ bundle exec rake spec
