# A description of what this class does
#
# @summary Manages Sentry's services
class sentry::service {
  service { ['sentry-cron',
              'sentry-worker',
              'sentry-web']:
    ensure     => running,
    provider   => 'systemd',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
