require 'spec_helper'

describe "organizations/new" do
  before(:each) do
    assign(:organization, stub_model(Organization,
      :type => "",
      :unit_number => "MyString",
      :city => "MyString",
      :state => "MyString",
      :time_zone => "MyString"
    ).as_new_record)
  end

  it "renders new organization form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => organizations_path, :method => "post" do
      assert_select "input#organization_type", :name => "organization[type]"
      assert_select "input#organization_unit_number", :name => "organization[unit_number]"
      assert_select "input#organization_city", :name => "organization[city]"
      assert_select "input#organization_state", :name => "organization[state]"
      assert_select "input#organization_time_zone", :name => "organization[time_zone]"
    end
  end
end
