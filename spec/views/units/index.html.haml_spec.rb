# require 'rails_helper'

# describe "units/index" do
#   before(:each) do
#     assign(:units, [
#       stub_model(Unit,
#         :unit_type => "Unit Type",
#         :unit_number => "Unit Number",
#         :city => "City",
#         :state => "State",
#         :time_zone => "Time Zone"
#       ),
#       stub_model(Unit,
#         :unit_type => "Unit Type",
#         :unit_number => "Unit Number",
#         :city => "City",
#         :state => "State",
#         :time_zone => "Time Zone"
#       )
#     ])
#   end

#   it "renders a list of units" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => "Unit Type".to_s, :count => 2
#     assert_select "tr>td", :text => "Unit Number".to_s, :count => 2
#     assert_select "tr>td", :text => "City".to_s, :count => 2
#     assert_select "tr>td", :text => "State".to_s, :count => 2
#     assert_select "tr>td", :text => "Time Zone".to_s, :count => 2
#   end
# end
