require 'spec_helper'

describe 'sentry' do
  on_supported_os.sort.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('sentry') }
      it { is_expected.to contain_class('sentry::install').that_comes_before('Class[sentry::config]') }
      it { is_expected.to contain_class('sentry::config').that_comes_before('Class[sentry::service]') }
      it { is_expected.to contain_class('sentry::service') }

      it { is_expected.to contain_file('/etc/sentry/sentry.conf.py') }
      it { is_expected.to contain_file('/etc/sentry/config.yml') }

      it { is_expected.to contain_service('sentry-worker')
        .with(
          :ensure => 'running',
          :enable => true,
        )
      }
      it { is_expected.to contain_service('sentry-cron')
        .with(
          :ensure => 'running',
          :enable => true,
        )
      }
      it { is_expected.to contain_service('sentry-web')
        .with(
          :ensure => 'running',
          :enable => true,
        )
      }
    end
  end
end
