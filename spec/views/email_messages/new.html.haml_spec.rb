# require 'spec_helper'

# describe "email_messages/new" do
#   before(:each) do
#     assign(:email_message, stub_model(EmailMessage,
#       :user_id => 1,
#       :message => "MyText",
#       :subject => "MyString"
#     ).as_new_record)
#   end

#   it "renders new email_message form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => email_messages_path, :method => "post" do
#       assert_select "input#email_message_user_id", :name => "email_message[user_id]"
#       assert_select "textarea#email_message_message", :name => "email_message[message]"
#       assert_select "input#email_message_subject", :name => "email_message[subject]"
#     end
#   end
# end
