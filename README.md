# supervisor

Puppet module to manage [supervisor](http://supervisord.org/). Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.


#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with supervisor](#setup)
    * [What supervisor affects](#what-supervisor-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with supervisor](#beginning-with-supervisor)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Puppet module for configuring the 'supervisor' daemon control
utility. 

This fork installs the package using pip rather than system packages, since some OS supervisor packages are hopelessly out-of-date. I've also added 
some support for supervisor extensions (specifically superlance/httpok, but can easily be extended).

## Setup

### Setup Requirements **OPTIONAL**

### Beginning with supervisor

`include supervisor` should be sufficient to just manage supervisord. To manage services with supervisord, some additional config is needed.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your users how to use your module to solve problems, and be sure to include code examples. Include three to five examples of the most important or common tasks a user can accomplish with your module. Show users how to accomplish more complex tasks that involve different types, classes, and functions working in tandem.

```puppet
  include supervisor

  supervisor::services { 'http-app':
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
    address  => 'http://127.0.0.1/',
    url      => 'test',
    port     => 8000,
    code     => '200',
    numprocs => 4
  }
```

Or manage with hiera:

```yaml
supervisor::services:
  http-app:
    ensure: present
    enable: true
    user: 'http-user'
    directory: '/var/www/http-app'
    numprocs: 4
    numprocs_start: 8000
    command: "/var/www/http-app/app.py --host 127.0.0.1 --port %(process_num)s"
    redirect_stderr: true
    stdout_logfile: "/var/log/supervivor/http-app-%(process_num)s.log"
    stdout_logfile_keep: 10
    stdout_logfile_maxsize: 25MB
    stderr_logfile: "/var/log/supervisor/http-app-%(process_num)s.error.log"
    stderr_logfile_keep: 10
    stderr_logfile_maxsize: 50MB
    priority: 888
```

## Reference

Read more in the [Reference section](REFERENCE.md).

This section was generated using Puppet Strings. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

Read more in the [Contributing section](CONTRIBUTING.md).

## Release Notes/Contributors/Etc.

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
