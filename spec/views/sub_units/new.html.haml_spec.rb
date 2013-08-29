# require 'spec_helper'

# describe "sub_units/new" do
#   before(:each) do
#     assign(:sub_unit, stub_model(SubUnit,
#       :unit_id => 1,
#       :name => "MyString",
#       :description => "MyText"
#     ).as_new_record)
#   end

#   it "renders new sub_unit form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => sub_units_path, :method => "post" do
#       assert_select "input#sub_unit_unit_id", :name => "sub_unit[unit_id]"
#       assert_select "input#sub_unit_name", :name => "sub_unit[name]"
#       assert_select "textarea#sub_unit_description", :name => "sub_unit[description]"
#     end
#   end
# end
