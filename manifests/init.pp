# Class sentry
class sentry (
  Integer $port = 9000,
  Integer $redis_port = 6379,
  String $postgres_user = 'sentry',
  String $postgres_password = 'sentry',
  Integer $postgres_port = 5432,
  Enum['smtp', 'console', 'dummy'] $mail_backend = 'dummy',
  String $mail_host = '',
  String $mail_username = '',
  String $mail_password = '',
  String $mail_from = '',
) {

  include sentry::install
  include sentry::service
  include sentry::config

  Class['sentry::install']
    ->Class['sentry::config']
      ~>Class['sentry::service']
}
