# require 'spec_helper'

# describe "event_signups/index" do
#   before(:each) do
#     assign(:event_signups, [
#       stub_model(EventSignup,
#         :event => nil,
#         :scouts => "Scouts",
#         :adults => "Adults",
#         :siblings => "Siblings",
#         :comment => "MyText"
#       ),
#       stub_model(EventSignup,
#         :event => nil,
#         :scouts => "Scouts",
#         :adults => "Adults",
#         :siblings => "Siblings",
#         :comment => "MyText"
#       )
#     ])
#   end

#   it "renders a list of event_signups" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => nil.to_s, :count => 2
#     assert_select "tr>td", :text => "Scouts".to_s, :count => 2
#     assert_select "tr>td", :text => "Adults".to_s, :count => 2
#     assert_select "tr>td", :text => "Siblings".to_s, :count => 2
#     assert_select "tr>td", :text => "MyText".to_s, :count => 2
#   end
# end
