require 'spec_helper'

describe "sub_units/edit" do
  before(:each) do
    @sub_unit = assign(:sub_unit, stub_model(SubUnit,
      :organization_id => 1,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit sub_unit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sub_units_path(@sub_unit), :method => "post" do
      assert_select "input#sub_unit_organization_id", :name => "sub_unit[organization_id]"
      assert_select "input#sub_unit_name", :name => "sub_unit[name]"
      assert_select "textarea#sub_unit_description", :name => "sub_unit[description]"
    end
  end
end
