require 'spec_helper'

RSpec.describe Scout do
  specify { expect(FactoryGirl.build(:scout)).to be_valid }
  specify { expect(FactoryGirl.build(:scout).type).to eq('Scout') }

  specify { expect(FactoryGirl.build(:scout).scout?).to eq(true) }
  specify { expect(FactoryGirl.build(:scout).adult?).to eq(false) }
end
