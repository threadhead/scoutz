require "rails_helper"

RSpec.describe MessageMailer, type: :mailer do
  before do
    allow_any_instance_of(Event).to receive(:ical_valid?).and_call_original
    @unit = FactoryGirl.create(:unit)
    @recipient = FactoryGirl.create(:adult)
    @recipient.units << @unit
    @sender = FactoryGirl.build_stubbed(:adult)
    @event = FactoryGirl.create(:event, unit: @unit)
    @email_message = FactoryGirl.create(:email_message, sender: @sender, unit: @unit, message: "<em>A Message Today!</em>")
    @email_message.events << @event
  end

  shared_examples 'renders unsubscribe block' do
    it 'renders unsubscribe block' do
      expect(mail.body.encoded).to include("UNSUBSCRIBE")
      expect(mail.body.encoded).to include("All times (GMT-07:00) Arizona")
      expect(mail.body.encoded).to include("<a href=\"http://www.testing.com/unsubscribe/blast_email?id=#{@recipient.signup_token}\">")
    end
  end

  shared_examples 'renders headers' do
    it "renders the headers" do
      expect(mail.subject).to eq("[CS Pack 134] Email Test Message Subject")
      expect(mail.to).to eq([@recipient.email])
      expect(mail.reply_to).to eq([@sender.email])
      expect(mail.from).to eq(["noreply@scoutt.in"])
    end
  end

  shared_examples 'renders body' do
    it 'renders the body' do
      expect(mail.body.encoded).to include("<em>A Message Today!</em>")
    end
  end




  describe "email_blast_no_events" do
    let(:mail) { MessageMailer.email_blast(@recipient, @email_message) }

    include_examples 'renders headers'
    include_examples 'renders unsubscribe block'
    include_examples 'renders body'

    it 'does not renders events' do
      @event.delete
      expect(mail.body.encoded).to_not include("USS Midway Overnight")
    end
  end



  describe "email_blast_with_events" do
    let(:mail) { MessageMailer.email_blast(@recipient, @email_message) }

    include_examples 'renders headers'
    include_examples 'renders unsubscribe block'
    include_examples 'renders body'

    it 'renders events' do
      expect(mail.body.encoded).to include("USS Midway Overnight")
      expect(mail.body.encoded).to include("<img src=\"http://www.testing.com/assets/ical_email.png\"")
    end
  end

end
