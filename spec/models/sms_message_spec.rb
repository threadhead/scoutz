require 'spec_helper'

RSpec.describe SmsMessage do
  it { is_expected.to belong_to(:unit) }
  it { is_expected.to belong_to(:sender) }
  it { is_expected.to have_and_belong_to_many(:users) }

  it { is_expected.to validate_presence_of(:message) }

  describe 'validations' do
    let(:sms_message) { FactoryGirl.build(:sms_message) }

    specify { expect(sms_message).to be_valid }

    it 'invalid when no user_ids when send to users selected' do
      sms_message.send_to_option = 4
      expect(sms_message).not_to be_valid
      expect(sms_message.errors.count).to eq(1)
      expect(sms_message.errors).to include(:base)
    end

    it 'valid when user_ids when send to users selected' do
      user = FactoryGirl.create(:adult)
      sms_message.send_to_option = 4
      sms_message.user_ids = [user.id]
      expect(sms_message).to be_valid
    end
  end

end
