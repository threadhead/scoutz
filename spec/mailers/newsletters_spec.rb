require "rails_helper"

RSpec.describe Newsletters, type: :mailer do
  before do
    allow_any_instance_of(Event).to receive(:ical_valid?).and_call_original
    @unit = FactoryGirl.create(:unit)
    @recipient = FactoryGirl.create(:adult)
    @recipient.units << @unit
    @event = FactoryGirl.create(:event, unit: @unit)
    @event.update_ical
    allow(@unit).to receive_message_chain(:events, :newsletter_next_week, :by_start).and_return([@event])
  end


  describe "weekly" do
    let(:mail) { Newsletters.weekly(@recipient, @unit) }

    it "renders the headers" do
      expect(mail.subject).to include("[CS Pack 134] Upcoming Events for the week of")
      expect(mail.to).to eq([@recipient.email])
      expect(mail.from).to eq(['noreply@scoutt.in'])
    end

    it 'renders unsubscribe block' do
      expect(mail.body.encoded).to include("UNSUBSCRIBE")
      expect(mail.body.encoded).to include("All times (GMT-07:00) Arizona")
      expect(mail.body.encoded).to include("href=\"http://www.testing.com/unsubscribe/weekly_newsletter_email?id=#{@recipient.signup_token}\"")
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("USS Midway Overnight")
      expect(mail.body.encoded).to include(@event.ical.url)
      expect(mail.body.encoded).to include(event_url(@event))
    end
  end

end
