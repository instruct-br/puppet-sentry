[![Build Status](https://travis-ci.org/instruct-br/puppet-sentry.svg?branch=master)](https://travis-ci.org/instruct-br/puppet-sentry) ![License](https://img.shields.io/badge/license-Apache%202-blue.svg) ![Version](https://img.shields.io/puppetforge/v/instructbr/sentry.svg) ![Downloads](https://img.shields.io/puppetforge/dt/instructbr/sentry.svg)

# sentry

#### Table of contents

1. [Overview](#overview)
1. [Supported Platforms](#supported-platforms)
1. [Requirements](#requirements)
1. [Installation](#installation)
1. [Usage](#usage)
1. [References](#references)
1. [Limitations](#limitations)
1. [Development](#development)

## Overview

This module will install Sentry and its dependencies (Postgresql and Redis).

It will also manage Sentry's configurations.

## Supported Platforms

This module was tested under these platforms, all in x86_64 arch:

- CentOS 7

## Requirements

### Pre-Reqs

You need internet access to install packages.

- Puppet >= 5.x
  - Hiera >= 3.4
  - Facter >= 2.5

## Installation

Via git:

    # cd /etc/puppetlabs/code/environment/production/modules
    # git clone https://github.com/instruct-br/puppet-sentry.git sentry

Via puppet:

    # puppet module install instruct/sentry

Via `puppetfile`:

    mod 'instruct-sentry'

## Usage

### Quick run

    puppet apply -e "include sentry"

### Using with parameters

#### Examples in CentOS 7

Using default parameters values:

```puppet
include sentry
```

Installing without mail configurations:

```puppet
class { 'sentry':
  port              => 5000,
  redis_port        => 6380,
  postgres_user     => 'sentry_user',
  postgres_password => 'sentry_pass',
  postgres_port     => '5433',
}
```

Installing and configuring SMTP:

```puppet
class { 'sentry':
  port              => 5000,
  redis_port        => 6380,
  postgres_user     => 'sentry_user',
  postgres_password => 'sentry_pass',
  postgres_port     => '5433',
  mail_backend      => 'smtp',
  mail_host         => 'http://smtp-adress.com',
  mail_username     => 'smtp_user',
  mail_password     => 'smtp_pass',
  mail_from         => 'smtp_user@smtpserver.com',
}
```

## References

### Classes

```puppet
sentry
sentry::install (private)
sentry::config (private)
sentry::service (private)
```

### Parameters type

#### `port`

Type: Integer

Integer to configure Sentry's port. Default to 9000

#### `redis_port`

Type: Integer

Integer to configure Redis port. Default to 6379.

#### `postgres_user`

Type: String

String to configure Sentry's user for Postgresql. Default to 'sentry'.

#### `postgres_password`

Type: String

String to configure Sentry's password for Postgresql. Default to 'sentry'.

#### `postgres_port`

Type: Integer

Integer to configure Postgres port. Default to 5432.

#### `mail_backend`

Type: Enum['smtp', 'console', 'dummy']

String to configure Sentry's mail backend. Accepted values are 'smtp', 'console' and 'dummy'. Use 'dummy' if you do not want to configure Sentry's mail. Default to 'dummy'.

#### `mail_host`

Type: String

String to configure the mail host. Default to an empty string.

#### `mail_username`

Type: String

String to configure username to log in the mail host. Default to an empty string.

#### `mail_password`

Type: String

String to configure password to log in the mail host. String to configure Default to an empty string.

#### `mail_from`

Type: String

String to configure default mail sender. Default to an empty string.


## Limitations

- After installing and configuring Sentry using this module, you will still need to run the `sentry createuser` command to create your user.
- This module was tested only in CentOS 7.

## Development

### My dev environment

This module was developed using

- Puppet 5.5.3
  - Facter 3.11.2
- CentOS 7.5
- VirtualBox 5.2.10
- Vagrant 2.0.2

### Testing

This module uses puppet-lint, puppet-syntax, metadata-json-lint and rspec-puppet. We hope you use them before submitting your PR.

#### Installing gems

    gem install bundler --no-document
    bundle install --without development

#### Running syntax tests

    bundle exec rake syntax
    bundle exec rake lint
    bundle exec rake metadata_lint

#### Running unit tests

    bundle exec rake spec

### Author

Igor Oliveira (igor at instruct dot com dot br)

### Contributors
