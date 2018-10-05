# Configures the environment, installs necessary system packages and isntalls Sentry via pip
#
# @summary Installs Sentry and its dependencies
class sentry::install {

  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    use_epel   => true,
  }

  if $sentry::manage_postgres {
    class { 'postgresql::server':
      port => $sentry::postgres_port,
    }
  }

  if $sentry::manage_redis {
    package { 'redis':
      ensure  => installed,
      require => Class['python'],
      notify  => Service['redis'],
    }
  }

  package { ['python-setuptools', 'gcc', 'gcc-c++', 'libffi-devel', 'libjpeg-devel',
              'libxml2-devel', 'libxslt-devel', 'libyaml-devel', 'libpqxx-devel']:
    ensure  => installed,
    require => Class['python']
  }

  group { 'sentry':
    ensure => present,
  }

  user { 'sentry':
    ensure     => present,
    managehome => true,
    groups     => ['sentry', 'root'],
  }

  file { '/www/':
    ensure => 'directory',
    owner  => 'sentry',
  }

  python::virtualenv { '/www/sentry/':
    ensure     => present,
    version    => '2.7',
    systempkgs => true,
    owner      => 'sentry',
    group      => 'sentry',
  }

  python::pip { 'install-sentry' :
    ensure     => 'latest',
    pkgname    => 'sentry',
    virtualenv => '/www/sentry',
    owner      => 'sentry',
  }

  service { 'redis':
    ensure   => running,
    provider => 'systemd',
    enable   => true,
  }

}
