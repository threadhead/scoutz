require "rails_helper"

RSpec.describe AdminMailer, :type => :mailer do
  describe "send_existing_user_welcome" do
    let(:mail) { AdminMailer.send_existing_user_welcome }

    it "renders the headers" do
      expect(mail.subject).to eq("Send existing user welcome")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
