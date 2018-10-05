# Manages services
#
# @summary Manages services
class sentry::service {

  service { ['sentry-cron',
              'sentry-worker',
              'sentry-web']:
    ensure   => running,
    provider => 'systemd',
    enable   => true,
  }

}
