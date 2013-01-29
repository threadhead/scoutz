# require 'spec_helper'

# describe "events/show" do
#   before(:each) do
#     @event = assign(:event, stub_model(Event,
#       :organization_id => 1,
#       :kind => "Kind",
#       :name => "Name",
#       :user_id => 2,
#       :send_reminders => false,
#       :notifier_type => "Notifier Type",
#       :signup_required => false,
#       :location_name => "Location Name",
#       :location_address1 => "Location Address1",
#       :location_address2 => "Location Address2",
#       :location_city => "Location City",
#       :location_state => "Location State",
#       :location_zip_code => "Location Zip Code",
#       :location_map_url => "Location Map Url",
#       :attire => "Attire"
#     ))
#   end

#   it "renders attributes in <p>" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     rendered.should match(/1/)
#     rendered.should match(/Kind/)
#     rendered.should match(/Name/)
#     rendered.should match(/2/)
#     rendered.should match(/false/)
#     rendered.should match(/Notifier Type/)
#     rendered.should match(/false/)
#     rendered.should match(/Location Name/)
#     rendered.should match(/Location Address1/)
#     rendered.should match(/Location Address2/)
#     rendered.should match(/Location City/)
#     rendered.should match(/Location State/)
#     rendered.should match(/Location Zip Code/)
#     rendered.should match(/Location Map Url/)
#     rendered.should match(/Attire/)
#   end
# end
