# require 'spec_helper'

# RSpec.describe "sms_messages/index", :type => :view do
#   before(:each) do
#     assign(:sms_messages, [
#       SmsMessage.create!(
#         :user => nil,
#         :event => nil,
#         :message => "MyText",
#         :sub_unit_ids => "Sub Unit Ids",
#         :send_to_option => 1
#       ),
#       SmsMessage.create!(
#         :user => nil,
#         :event => nil,
#         :message => "MyText",
#         :sub_unit_ids => "Sub Unit Ids",
#         :send_to_option => 1
#       )
#     ])
#   end

#   it "renders a list of sms_messages" do
#     render
#     assert_select "tr>td", :text => nil.to_s, :count => 2
#     assert_select "tr>td", :text => nil.to_s, :count => 2
#     assert_select "tr>td", :text => "MyText".to_s, :count => 2
#     assert_select "tr>td", :text => "Sub Unit Ids".to_s, :count => 2
#     assert_select "tr>td", :text => 1.to_s, :count => 2
#   end
# end
