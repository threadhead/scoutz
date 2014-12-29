require 'rails_helper'

RSpec.describe Phone do
  let(:phone) { FactoryGirl.build(:home_phone, user_id: 999) }

  it { should belong_to(:user).touch(true) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number).scoped_to(:user_id) }

  it 'validates uniqueness of kind scoped to user' do
    phone.save
    expect(FactoryGirl.build(:home_phone, user_id: phone.user_id, number: '8882221111')).not_to be_valid
  end

  specify { expect(phone).to be_valid }

  it 'remove non-digit characters from number' do
    phone.number = '555-222-1111'
    expect(phone.number).to eq('5552221111')
    phone.number = 'asdf555-222-1111asdf'
    expect(phone.number).to eq('5552221111')
    phone.number = '--++555-222-1111=++--!@#$%^&*()'
    expect(phone.number).to eq('5552221111')
  end
end
