require 'spec_helper'

describe "events/index" do
  before(:each) do
    assign(:events, [
      stub_model(Event,
        :organization_id => 1,
        :kind => "Kind",
        :name => "Name",
        :user_id => 2,
        :send_reminders => false,
        :notifier_type => "Notifier Type",
        :signup_required => false,
        :location_name => "Location Name",
        :location_address1 => "Location Address1",
        :location_address2 => "Location Address2",
        :location_city => "Location City",
        :location_state => "Location State",
        :location_zip_code => "Location Zip Code",
        :location_map_url => "Location Map Url",
        :attire => "Attire"
      ),
      stub_model(Event,
        :organization_id => 1,
        :kind => "Kind",
        :name => "Name",
        :user_id => 2,
        :send_reminders => false,
        :notifier_type => "Notifier Type",
        :signup_required => false,
        :location_name => "Location Name",
        :location_address1 => "Location Address1",
        :location_address2 => "Location Address2",
        :location_city => "Location City",
        :location_state => "Location State",
        :location_zip_code => "Location Zip Code",
        :location_map_url => "Location Map Url",
        :attire => "Attire"
      )
    ])
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Notifier Type".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Location Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location Address1".to_s, :count => 2
    assert_select "tr>td", :text => "Location Address2".to_s, :count => 2
    assert_select "tr>td", :text => "Location City".to_s, :count => 2
    assert_select "tr>td", :text => "Location State".to_s, :count => 2
    assert_select "tr>td", :text => "Location Zip Code".to_s, :count => 2
    assert_select "tr>td", :text => "Location Map Url".to_s, :count => 2
    assert_select "tr>td", :text => "Attire".to_s, :count => 2
  end
end
