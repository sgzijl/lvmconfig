require 'spec_helper'
require 'hiera'

describe 'lvmconfig' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  it 'should include lvmconfig' do
    should contain_class('lvmconfig')
  end

  it 'should include stdlib' do
    should contain_class('stdlib')
  end

  it 'should contain vgs' do
    should contain_volume_group('vg01').with(
      'ensure' => 'present',
      'physical_volumes' => '/dev/sdb'
    )
  end

  it 'should contain logical volumes' do
    should contain_logical_volume('backup').with(
      'volume_group' => 'vg01',
      'size'         => '100M',
    )
  end
end
