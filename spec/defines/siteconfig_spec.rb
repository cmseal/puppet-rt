require 'spec_helper'
describe 'rt::siteconfig', :type => :define do
  let(:title) { 'Test' }
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }

  # we do not have defaults for some parameters so the define should fail
  context 'with defaults for all parameters' do
    let (:params) {{}}

    it 'should fail on empty value' do
      expect { should compile }.to \
        raise_error(RSpec::Expectations::ExpectationNotMetError,
          /Value must be defined/)
    end
  end

  context 'with basic params' do
    let(:params) {
      {
        'ensure' => 'present',
      }
    }
    context 'should have a properly value defined ' do
      it 'Hash' do
        params.merge!({ 'value' => {
          'param1'              => 'test value1',
          'param2'              => 'test value2',
        }})
        should contain_file('/etc/rt/RT_SiteConfig.d/Test.pm').with(
          {
            'ensure'  => 'present',
            'mode'    => '0640',
            'owner'   => 'apache',
            'group'   => 'apache',
            'content' => "# File is generated by puppet
use utf8;
Set(%Test,
  'param1' => 'test value1',
  'param2' => 'test value2',
);
1;
"
          },
        )
      end
      it 'Array' do
        params.merge!({ 'value' => [
          'param1',
          'param2',
        ]})
        should contain_file('/etc/rt/RT_SiteConfig.d/Test.pm').with(
          {
            'ensure'  => 'present',
            'mode'    => '0640',
            'owner'   => 'apache',
            'group'   => 'apache',
            'content' => "# File is generated by puppet
use utf8;
Set(@Test,
  'param1',
  'param2',
);
1;
"
          },
        )
      end
      it 'String' do
        params.merge!({
          'value' => 'Test value'
        })
        should contain_file('/etc/rt/RT_SiteConfig.d/Test.pm').with(
          {
            'ensure'  => 'present',
            'mode'    => '0640',
            'owner'   => 'apache',
            'group'   => 'apache',
            'content' => "# File is generated by puppet
use utf8;
Set($Test, 'Test value');
1;
"
          },
        )
      end
    end
    it "should do syntax check" do
      params.merge!({
        'value' => 'Test value'
      })
      should contain_exec("Test syntax check")
    end
  end
end

# vim: ts=2 sw=2 sts=2 et :
