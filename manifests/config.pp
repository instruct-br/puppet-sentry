# A description of what this class does
#
# @summary Installs dependencies and configures Sentry
class sentry::config {

  package { ['postgresql-contrib',
            'redis']:
    ensure  => 'installed',
    require => Class['python'],
    before  => [Postgresql::Server::Extension['citext'], Exec['init-sentry']],
  }

  class { 'postgresql::server':
    port => $sentry::postgres_port,
  }

  postgresql::server::db { 'sentry':
    user     => $sentry::postgres_user,
    password => postgresql_password($sentry::postgres_user, $sentry::postgres_password),
  }

  postgresql::server::extension { 'citext':
    ensure   => 'present',
    database => 'sentry',
    require  => Postgresql::Server::Db['sentry'],
  }

  file { '/etc/sentry':
    ensure => 'absent',
    force  => true,
  }

  exec { 'init-sentry':
    command  => 'SENTRY_CONF=/etc/sentry /www/sentry/bin/sentry init /etc/sentry',
    provider => 'shell',
    require  => [Python::Pip['install-sentry'], Postgresql::Server::Extension['citext']],
  }

  file { '/etc/sentry/sentry.conf.py':
    ensure  => present,
    owner   => 'sentry',
    content => epp('sentry/sentry.conf.py.epp', {
      postgres_user     => $sentry::postgres_user,
      postgres_password => $sentry::postgres_password,
      postgres_port     => $sentry::postgres_port,
      sentry_port       => $sentry::port,
    }),
    require => Exec['init-sentry'],
    before  => Exec['upgrade-sentry'],
  }

  file { '/etc/sentry/config.yml':
    ensure  => present,
    owner   => 'sentry',
    content => epp('sentry/config.yml.epp', {
      mail_backend  => $sentry::mail_backend,
      mail_host     => $sentry::mail_host,
      mail_username => $sentry::mail_username,
      mail_password => $sentry::mail_password,
      mail_from     => $sentry::mail_from,
    }),
    require => Exec['init-sentry'],
    before  => Exec['upgrade-sentry'],
  }

  exec { 'upgrade-sentry':
    command  => 'SENTRY_CONF=/etc/sentry /www/sentry/bin/sentry upgrade --noinput',
    timeout  => 0,
    provider => 'shell',
  }

  file { '/etc/systemd/system/sentry-web.service':
    mode   => '0644',
    source => 'puppet:///modules/sentry/sentry-web.service',
  }

  file { '/etc/systemd/system/sentry-cron.service':
    mode   => '0644',
    source => 'puppet:///modules/sentry/sentry-cron.service',
  }

  file { '/etc/systemd/system/sentry-worker.service':
    mode   => '0644',
    source => 'puppet:///modules/sentry/sentry-worker.service',
  }
}
