require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe NewsletterWeeklyJob, type: :job do
  before do
    @unit = FactoryGirl.create(:unit)
    @user = FactoryGirl.create(:user, weekly_newsletter_email: true)
    @user.units << @unit

    @news_mock = double(Newsletters)
    allow(Newsletters).to receive(:weekly).and_return(@news_mock)
  end

  after { travel_back }


  it 'sets the weekly_newsletter_sent_at to current time after sending' do
    allow(@news_mock).to receive(:deliver_later)
    travel_to Time.new(2015, 1, 27, 5, 5, 5)
    NewsletterWeeklyJob.perform_now

    @unit.reload
    expect(@unit.weekly_newsletter_sent_at).to be_within(2).of(Time.zone.now)
  end

  it 'will send newsletter if not sent this week' do
    travel_to Time.new(2015, 1, 27, 5, 5, 5)
    @unit.update_column(:weekly_newsletter_sent_at, 1.week.ago)
    expect(@news_mock).to receive(:deliver_later)

    NewsletterWeeklyJob.perform_now
  end

  it 'will send newsletter if weekly_newsletter_sent_at is nil' do
    travel_to Time.new(2015, 1, 27, 5, 5, 5)
    expect(@news_mock).to receive(:deliver_later)

    NewsletterWeeklyJob.perform_now
  end

  it 'will not send newsletter if already sent this week' do
    travel_to Time.new(2015, 1, 27, 5, 5, 5)
    @unit.update_column(:weekly_newsletter_sent_at, Time.zone.now)
    expect(@news_mock).to receive(:deliver_later).exactly(0).times

    NewsletterWeeklyJob.perform_now
  end



end
