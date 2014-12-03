require 'rails_helper'

RSpec.describe "Status" do
  describe "GET /ping/<secret_ping_key>" do
    before { get "/ping/#{ENV['PING_KEY']}" }

    specify{ expect(response.status).to eq(200) }
    specify{ expect(response.body).to eq('ok') }
    specify{ expect(response.content_type).to eq(Mime::TEXT) }
  end
end
