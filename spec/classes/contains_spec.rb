# frozen_string_literal: true

require 'spec_helper'

describe 'supervisor' do
  let(:facts) { { is_virtual: false } }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(super())
      end

      it { is_expected.to compile.with_all_deps }
      describe 'Testing the dependancies between the classes' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('supervisor') }
        it { is_expected.to contain_class('supervisor::install').that_comes_before('Class[supervisor::config]') }
        it { is_expected.to contain_class('supervisor::config').that_notifies('Class[supervisor::system_service]') }
        it { is_expected.to contain_class('supervisor::system_service') }
      end
    end
  end
end
