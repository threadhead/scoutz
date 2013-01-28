# require 'spec_helper'

# describe "events/edit" do
#   before(:each) do
#     @event = assign(:event, stub_model(Event,
#       :organization_id => 1,
#       :kind => "MyString",
#       :name => "MyString",
#       :user_id => 1,
#       :send_reminders => false,
#       :notifier_type => "MyString",
#       :signup_required => false,
#       :location_name => "MyString",
#       :location_address1 => "MyString",
#       :location_address2 => "MyString",
#       :location_city => "MyString",
#       :location_state => "MyString",
#       :location_zip_code => "MyString",
#       :location_map_url => "MyString",
#       :attire => "MyString"
#     ))
#   end

#   it "renders the edit event form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => events_path(@event), :method => "post" do
#       assert_select "input#event_organization_id", :name => "event[organization_id]"
#       assert_select "input#event_kind", :name => "event[kind]"
#       assert_select "input#event_name", :name => "event[name]"
#       assert_select "input#event_user_id", :name => "event[user_id]"
#       assert_select "input#event_send_reminders", :name => "event[send_reminders]"
#       assert_select "input#event_notifier_type", :name => "event[notifier_type]"
#       assert_select "input#event_signup_required", :name => "event[signup_required]"
#       assert_select "input#event_location_name", :name => "event[location_name]"
#       assert_select "input#event_location_address1", :name => "event[location_address1]"
#       assert_select "input#event_location_address2", :name => "event[location_address2]"
#       assert_select "input#event_location_city", :name => "event[location_city]"
#       assert_select "input#event_location_state", :name => "event[location_state]"
#       assert_select "input#event_location_zip_code", :name => "event[location_zip_code]"
#       assert_select "input#event_location_map_url", :name => "event[location_map_url]"
#       assert_select "input#event_attire", :name => "event[attire]"
#     end
#   end
# end
