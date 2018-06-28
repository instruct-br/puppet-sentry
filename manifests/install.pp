# A description of what this class does
#
# @summary Configures the environment, installs necessary system packages and isntalls Sentry via pip
class sentry::install {
  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    use_epel   => true,
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
}
