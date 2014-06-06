require 'spec_helper'

RSpec.describe SmsMessage do
  let(:sms_message) { FactoryGirl.build(:sms_message) }

  it { is_expected.to belong_to(:unit) }
  it { is_expected.to belong_to(:sender) }
  it { is_expected.to have_and_belong_to_many(:users) }

  it { is_expected.to validate_presence_of(:message) }

  describe 'validations' do
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

  context 'before saving' do
    it 'message should be sanitized' do
      expect(Sanitize).to receive(:clean).exactly(1).times
      sms_message.save
    end
  end

  describe '.send_to_count' do
    it 'returns 0 when there are no recipients' do
      allow(sms_message).to receive(:recipients).and_return(nil)
      expect(sms_message.send_to_count).to eq(0)
    end

    it 'returns the cout when there are recipients' do
      allow(sms_message).to receive(:recipients).and_return([mock_model(User), mock_model(User)])
      expect(sms_message.send_to_count).to eq(2)
    end
  end

  describe '.recipients_emails' do
    it 'returns a unique array of sms email addresses' do
      u1 = FactoryGirl.build(:user, sms_number: '4445551111', sms_provider: 'Verizon')
      u2 = FactoryGirl.build(:user, sms_number: '4445551111', sms_provider: 'Verizon')
      allow(sms_message).to receive(:recipients).and_return([u1, u2])
      expect(sms_message.recipients_emails).to eq(["4445551111@vtext.com"])
    end
  end

  describe '.send_sms' do
    before do
      ActionMailer::Base.deliveries.clear
      u1 = FactoryGirl.build(:user, sms_number: '4445551111', sms_provider: 'Verizon')
      u2 = FactoryGirl.build(:user, sms_number: '4445552222', sms_provider: 'Verizon')
      allow(sms_message).to receive(:recipients).and_return([u1, u2])
      sms_message.save
      sms_message.send_sms
    end

    specify { expect(sms_message.reload.sent_at).to be_within(5).of(Time.zone.now) }
    specify { expect(ActionMailer::Base.deliveries.size).to eq(2) }
  end


  describe 'SmsMessage.dj_send_sms' do
    it 'finds the SmsMessage and call its send_sms' do
      msm = mock_model SmsMessage
      expect(SmsMessage).to receive(:find).exactly(1).times.and_return(msm)
      expect(msm).to receive(:send_sms).exactly(1).times
      SmsMessage.dj_send_sms(3)
    end
  end

end
