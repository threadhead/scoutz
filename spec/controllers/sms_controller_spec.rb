require 'spec_helper'

describe SmsController do

  describe "GET 'send_verification'" do
    it "returns http success" do
      get 'send_verification'
      response.should be_success
    end
  end

end
