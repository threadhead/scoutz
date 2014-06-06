require 'spec_helper'

RSpec.describe Scout do
  it 'should be valid' do
    FactoryGirl.build(:scout).should be_valid
  end

  it 'has type: \'Scout\'' do
    FactoryGirl.build(:scout).type.should eq('Scout')
  end
end
