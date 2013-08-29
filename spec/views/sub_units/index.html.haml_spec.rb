# require 'spec_helper'

# describe "sub_units/index" do
#   before(:each) do
#     assign(:sub_units, [
#       stub_model(SubUnit,
#         :unit_id => 1,
#         :name => "Name",
#         :description => "MyText"
#       ),
#       stub_model(SubUnit,
#         :unit_id => 1,
#         :name => "Name",
#         :description => "MyText"
#       )
#     ])
#   end

#   it "renders a list of sub_units" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => 1.to_s, :count => 2
#     assert_select "tr>td", :text => "Name".to_s, :count => 2
#     assert_select "tr>td", :text => "MyText".to_s, :count => 2
#   end
# end
