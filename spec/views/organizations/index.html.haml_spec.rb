require 'spec_helper'

describe "organizations/index" do
  before(:each) do
    assign(:organizations, [
      stub_model(Organization,
        :type => "Type",
        :unit_number => "Unit Number",
        :city => "City",
        :state => "State",
        :time_zone => "Time Zone"
      ),
      stub_model(Organization,
        :type => "Type",
        :unit_number => "Unit Number",
        :city => "City",
        :state => "State",
        :time_zone => "Time Zone"
      )
    ])
  end

  it "renders a list of organizations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Unit Number".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Time Zone".to_s, :count => 2
  end
end
