require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  before do
    allow_any_instance_of(Event).to receive(:ical_valid?).and_call_original
    @unit = FactoryGirl.create(:unit)
    @recipient = FactoryGirl.create(:adult)
    @recipient.units << @unit
    @event = FactoryGirl.create(:event, unit: @unit)
    @event.reload
  end


  describe "reminder" do
    let(:mail) { EventMailer.reminder(@event, @recipient) }

    it "renders the headers" do
      expect(mail.subject).to eq("[CS Pack 134] USS Midway Overnight - Reminder")
      expect(mail.to).to eq([@recipient.email])
      expect(mail.from).to eq(['noreply@scoutt.in'])
    end

    it 'renders unsubscribe block' do
      expect(mail.body.encoded).to include("UNSUBSCRIBE")
      expect(mail.body.encoded).to include("All times (GMT-07:00) Arizona")
      expect(mail.body.encoded).to include("<a href=\"http://www.testing.com/unsubscribe/event_reminder_email?id=#{@recipient.signup_token}\">")
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("USS Midway Overnight")
      expect(mail.body.encoded).to include("<img src=\"http://www.testing.com/assets/ical_email.png\"")
    end
  end

end
