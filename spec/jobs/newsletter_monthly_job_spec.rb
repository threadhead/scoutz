require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe NewsletterMonthlyJob, type: :job do
  before do
    @unit = FactoryGirl.create(:unit)
    @user = FactoryGirl.create(:user, monthly_newsletter_email: true)
    @user.units << @unit

    @news_mock = double(Newsletters)
    allow(Newsletters).to receive(:monthly).and_return(@news_mock)
  end

  after { travel_back }


  describe 'trigger date' do
    before do
      allow(@unit).to receive(:update_column)
      @unit.update_column(:monthly_newsletter_sent_at, Time.new(2014, 12, 27, 5, 5, 5))
    end

    it 'only sends on the 5 day from the end of the month' do
      expect(@news_mock).to receive(:deliver_later)
      travel_to Time.new(2015, 1, 27, 5, 5, 5)

      NewsletterMonthlyJob.perform_now
    end

    it 'does not send on other days' do
      expect(@news_mock).to receive(:deliver_later).exactly(0).times

      ((1..26).to_a + (28..31).to_a).each do |day|
        travel_to Time.new(2015, 1, day, 5, 5, 5)
        NewsletterMonthlyJob.perform_now
      end
    end
  end

  it 'sets the monthly_newsletter_sent_at to current time after sending' do
    allow(@news_mock).to receive(:deliver_later)
    travel_to Time.new(2015, 1, 27, 5, 5, 5)
    NewsletterMonthlyJob.perform_now

    @unit.reload
    expect(@unit.monthly_newsletter_sent_at).to be_within(2).of(Time.zone.now)
  end

  it 'will not send newsletter if already sent this month' do
    travel_to Time.new(2015, 1, 27, 5, 5, 5)
    @unit.update_column(:monthly_newsletter_sent_at, Time.zone.now)
    expect(@news_mock).to receive(:deliver_later).exactly(0).times

    NewsletterMonthlyJob.perform_now
  end



end
