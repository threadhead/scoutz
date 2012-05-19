require 'spec_helper'

describe SubUnit do
  it { should belong_to(:organization) }
  it { should validate_presence_of(:name) }

  it 'validates uniqueness of name', :focus do
  	FactoryGirl.create(:sub_unit)
  	should validate_uniqueness_of(:name).case_insensitive.scoped_to(:organization_id)
  end

  it "should be valid" do
  	FactoryGirl.build(:sub_unit).should be_valid
  end
end
