require 'rails_helper'

RSpec.describe "EmailGroups", type: :request do
  describe "GET /email_groups" do
    it "works! (now write some real specs)" do
      get email_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
