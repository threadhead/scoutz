require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe PruneEmailMessagesJob, type: :job do
  before(:all) do
    @unit = FactoryGirl.create(:unit)
    @sender = FactoryGirl.create(:adult)
  end


  let(:email_message) { FactoryGirl.create(:email_message, unit: @unit, sender: @sender) }

  context 'destroying' do
    before do
      #stub out the logger
      logger_stub = double(Logger)
      allow(Logger).to receive(:new).and_return(logger_stub)
      allow(logger_stub).to receive(:info)
      allow(logger_stub).to receive(:close)
    end

    it 'finds EmailMessages from 1 year 7 months ago and destroys them' do
      em_id = email_message.id
      email_message.update_column(:created_at, 1.year.ago - 7.months - 1.hour)
      PruneEmailMessagesJob.perform_later
      expect(EmailMessage.exists?(em_id)).to eq(false)
    end

    it 'does not destroy email message newer than 1 year 7 months ago' do
      em_id = email_message.id
      email_message.update_column(:created_at, 1.year.ago - 7.months + 1.hour)
      PruneEmailMessagesJob.perform_later
      expect(EmailMessage.exists?(em_id)).to eq(true)
    end
  end

  it 'logs messages' do
    logger_stub = double(Logger)
    expect(Logger).to receive(:new).and_return(logger_stub)
    expect(logger_stub).to receive(:info).exactly(2).times
    expect(logger_stub).to receive(:close).exactly(1).times
    PruneEmailMessagesJob.perform_later
  end

end
