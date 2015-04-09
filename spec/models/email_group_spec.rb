require 'rails_helper'

RSpec.describe EmailGroup, type: :model do
  let (:unit) { FactoryGirl.build_stubbed(:unit) }
  let (:user) { FactoryGirl.build_stubbed(:adult) }
  let (:email_group) { FactoryGirl.build(:email_group, unit: unit, user: user ) }

  it { should belong_to(:unit) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:unit) }
  it { should validate_presence_of(:user) }

  specify { expect(email_group).to be_valid }

  describe 'users_ids validation' do
    it 'should not be empty' do
      email_group.users_ids = []
      expect(email_group).not_to be_valid
      expect(email_group.errors).to include(:base)
    end
  end


  describe '.users' do
    it 'returns user records' do
      unit1 = FactoryGirl.create(:unit)
      user1 = FactoryGirl.create(:adult)
      user1.units << unit1
      email_group1 = FactoryGirl.build(:email_group, unit: unit1, user: user1)

      expect(email_group1.users).to include(user1)
    end
  end
end
