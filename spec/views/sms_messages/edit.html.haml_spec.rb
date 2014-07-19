# require 'rails_helper'

# RSpec.describe "sms_messages/edit", :type => :view do
#   before(:each) do
#     @sms_message = assign(:sms_message, SmsMessage.create!(
#       :user => nil,
#       :event => nil,
#       :message => "MyText",
#       :sub_unit_ids => "MyString",
#       :send_to_option => 1
#     ))
#   end

#   it "renders the edit sms_message form" do
#     render

#     assert_select "form[action=?][method=?]", sms_message_path(@sms_message), "post" do

#       assert_select "input#sms_message_user_id[name=?]", "sms_message[user_id]"

#       assert_select "input#sms_message_event_id[name=?]", "sms_message[event_id]"

#       assert_select "textarea#sms_message_message[name=?]", "sms_message[message]"

#       assert_select "input#sms_message_sub_unit_ids[name=?]", "sms_message[sub_unit_ids]"

#       assert_select "input#sms_message_send_to_option[name=?]", "sms_message[send_to_option]"
#     end
#   end
# end
