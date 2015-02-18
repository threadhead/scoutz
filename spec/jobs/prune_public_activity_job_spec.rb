require 'rails_helper'

RSpec.describe PrunePublicActivityJob, type: :job do
  before do
    @pa1 = PublicActivity::Activity.create(trackable_type: 'EventSignup', key: 'event_signup.create')
    @pa1.update_column(:updated_at, 61.days.ago)
    @pa2 = PublicActivity::Activity.create(trackable_type: 'EventSignup', key: 'event_signup.create')
    @pa2.update_column(:updated_at, 59.days.ago)

  end

  context 'pruning' do
    before do
      #stub out the logger
      logger_stub = double(Logger)
      allow(Logger).to receive(:new).and_return(logger_stub)
      allow(logger_stub).to receive(:info)
      allow(logger_stub).to receive(:close)
    end

    it 'destroys activities older than 60 days ago (default days to prune)' do
      pa1_id = @pa1.id
      PrunePublicActivityJob.perform_later
      expect(PublicActivity::Activity.exists?(pa1_id)).to eq(false)
    end

    it 'does not destroy activities newer than 60 days ago' do
      pa2_id = @pa2.id
      PrunePublicActivityJob.perform_later
      expect(PublicActivity::Activity.exists?(pa2_id)).to eq(true)
    end
  end

  it 'logs messages' do
    logger_stub = double(Logger)
    expect(Logger).to receive(:new).and_return(logger_stub)
    expect(logger_stub).to receive(:info).exactly(3).times
    expect(logger_stub).to receive(:close).exactly(1).times
    PrunePublicActivityJob.perform_later
  end
end
