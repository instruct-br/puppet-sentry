# Installs and configures Sentry
#
# @summary Installs and configures Sentry
#
# @example
#   include sentry
class sentry (
  Integer $port                                  = 9000,
  Boolean $manage_redis                          = true,
  Boolean $manage_postgres                       = true,
  String $postgres_user                          = 'sentry',
  String $postgres_password                      = 'changeme',
  Integer $postgres_port                         = 5432,
  Enum['smtp', 'console', 'dummy'] $mail_backend = 'dummy',
  String $mail_host                              = '',
  String $mail_username                          = '',
  String $mail_password                          = '',
  String $mail_from                              = '',
) {

  include sentry::install
  include sentry::service
  include sentry::config

  Class['sentry::install']
  ->Class['sentry::config']
  ~>Class['sentry::service']
}
