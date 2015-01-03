require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  let(:recipient) { FactoryGirl.build_stubbed(:adult) }
  let(:token) { "asdf4321fdas" }


  describe "send_existing_user_welcome" do
    let(:mail) { AdminMailer.send_existing_user_welcome(recipient, token) }

    it "renders the headers" do
      expect(mail.subject).to include("Welcome to Scoutt.in!")
      expect(mail.to).to eq([recipient.email])
      expect(mail.from).to eq(['noreply@scoutt.in'])
    end

    it 'renders the body' do
      ap mail.body
      expect(mail.body.encoded).to include("An account has been created for you")
      expect(mail.body.encoded).to include("http://www.testing.com/user/welcome/edit?reset_password_token=asdf4321fdas")
    end
  end

end
