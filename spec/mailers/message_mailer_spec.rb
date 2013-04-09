require "spec_helper"

describe MessageMailer do
  describe "email_blast" do
    let(:mail) { MessageMailer.email_blast }

    it "renders the headers" do
      mail.subject.should eq("Email blast")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
