require 'spec_helper'

describe EmailMessage do
  it { should belong_to(:sender) }
  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:events) }

  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:subject) }

  it 'should be valid' do
    FactoryGirl.build(:email_message).should be_valid
  end

end
