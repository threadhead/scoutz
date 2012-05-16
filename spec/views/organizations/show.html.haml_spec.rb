require 'spec_helper'

describe "organizations/show" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :type => "Type",
      :unit_number => "Unit Number",
      :city => "City",
      :state => "State",
      :time_zone => "Time Zone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    rendered.should match(/Unit Number/)
    rendered.should match(/City/)
    rendered.should match(/State/)
    rendered.should match(/Time Zone/)
  end
end
