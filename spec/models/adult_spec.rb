require 'spec_helper'

describe Adult do
  it 'should be valid' do
    FactoryGirl.build(:adult).should be_valid
  end

  it 'has type: \'Adult\'' do
    FactoryGirl.build(:adult).type.should eq('Adult')
  end
end
