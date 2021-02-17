require 'spec_helper'

it { is_expected.to compile.with_all_deps }
describe 'Testing the dependancies between the classes' do
  it { is_expected.to contain_class('ntp::install') }
  it { is_expected.to contain_class('ntp::config') }
  it { is_expected.to contain_class('ntp::service') }
  it { is_expected.to contain_class('ntp::install').that_comes_before('Class[ntp::config]') }
  it { is_expected.to contain_class('ntp::service').that_subscribes_to('Class[ntp::config]') }
  it { is_expected.to contain_file('foo.rb').that_notifies('Service[ntp]') }
end
