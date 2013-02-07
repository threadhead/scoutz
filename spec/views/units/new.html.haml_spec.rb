# require 'spec_helper'

# describe "units/new" do
#   before(:each) do
#     assign(:unit, stub_model(Unit,
#       :unit_type => "Cub Scouts",
#       :unit_number => "MyString",
#       :city => "MyString",
#       :state => "MyString",
#       :time_zone => "MyString"
#     ).as_new_record)
#   end

#   it "renders new unit form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => units_path, :method => "post" do
#       assert_select "select#unit_unit_type", :name => "unit[unit_type]"
#       assert_select "input#unit_unit_number", :name => "unit[unit_number]"
#       assert_select "input#unit_city", :name => "unit[city]"
#       assert_select "select#unit_state", :name => "unit[state]"
#       assert_select "select#unit_time_zone", :name => "unit[time_zone]"
#     end
#   end
# end
