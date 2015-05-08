require 'rails_helper'

RSpec.describe MessageMailer, type: :mailer do
  before(:all) do
    @unit = FactoryGirl.create(:unit)
    @recipient = FactoryGirl.create(:adult)
    @recipient.units << @unit
    @sender = FactoryGirl.build_stubbed(:adult)
  end
  after(:all) { [@unit, @recipient].each(&:delete) }

  before(:each) do
    Event.class_variable_set(:@@disable_ical_generation, false)
    @event = FactoryGirl.create(:event, unit: @unit)
    @email_message = FactoryGirl.create(:email_message, sender: @sender, unit: @unit, message: '<em>A Message Today!</em>')
    @email_message.events << @event
    @email_attachment = FactoryGirl.create(:email_attachment)
    @email_message.email_attachments << @email_attachment
    allow(@email_message).to receive(:add_sent_confirmation!) # stub out setting of sent_to_hash
  end

  shared_examples 'renders unsubscribe block' do
    it 'renders unsubscribe block' do
      expect(mail.body.encoded).to include('UNSUBSCRIBE')
      expect(mail.body.encoded).to include('All times (GMT-07:00) Arizona')
      expect(mail.body.encoded).to include("href=\"http://www.testing.com/unsubscribe/blast_email?id=#{@recipient.signup_token}\"")
    end
  end

  shared_examples 'renders headers' do
    it 'renders the headers' do
      expect(mail.subject).to eq('Email Test Message Subject [CS Pack 134]')
      expect(mail.from).to eq(['noreply@scoutt.in'])
      expect(mail.to).to eq([@recipient.email])
      expect(mail.reply_to).to eq([@sender.email])
    end
  end

  shared_examples 'renders body' do
    it 'renders the body' do
      expect(mail.body.encoded).to include('<em>A Message Today!</em>')
    end
  end

  shared_examples 'renders attachments as links' do
    it 'renders attachments as links' do
      expect(mail.body.encoded).to include("href=\"http://www.testing.com#{@email_attachment.attachment.url}\"")
    end
  end


  describe 'email_blast with no events' do
    let(:mail) { MessageMailer.email_blast(@recipient, @email_message) }

    include_examples 'renders headers'
    include_examples 'renders unsubscribe block'
    include_examples 'renders body'
    include_examples 'renders attachments as links'

    it 'does not renders events' do
      @event.delete
      expect(mail.body.encoded).to_not include('USS Midway Overnight')
    end

    it 'does not render ical links' do
      @event.delete
      expect(mail.body.encoded).to_not include("src=\"http://www.testing.com/assets/ical_email.png\"")
    end
  end



  describe 'email_blast with events' do
    let(:mail) { MessageMailer.email_blast(@recipient, @email_message) }

    include_examples 'renders headers'
    include_examples 'renders unsubscribe block'
    include_examples 'renders body'
    include_examples 'renders attachments as links'

    it 'renders events' do
      expect(mail.body.encoded).to include('USS Midway Overnight')
      expect(mail.body.encoded).to include("<img src=\"http://www.testing.com/assets/ical_email.png\"")
    end

    it 'renders all ical links' do
      expect(mail.body.encoded).to include("href=\"http://www.testing.com#{@event.ical.url}\"")
    end
  end

end
