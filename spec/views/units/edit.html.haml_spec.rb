# require 'rails_helper'

# describe "units/edit" do
#   before(:each) do
#     @unit = assign(:unit, stub_model(Unit,
#       :unit_type => "Cub Scouts",
#       :unit_number => "MyString",
#       :city => "MyString",
#       :state => "MyString",
#       :time_zone => "MyString"
#     ))
#   end

#   it "renders the edit unit form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => units_path(@unit), :method => "post" do
#       assert_select "select#unit_unit_type", :name => "unit[unit_type]"
#       assert_select "input#unit_unit_number", :name => "unit[unit_number]"
#       assert_select "input#unit_city", :name => "unit[city]"
#       assert_select "select#unit_state", :name => "unit[state]"
#       assert_select "select#unit_time_zone", :name => "unit[time_zone]"
#     end
#   end
# end
